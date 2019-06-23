#!/usr/bin/env perl

use strict;
use warnings;

die "Usage: $0 registry_nick_name species_name <group_name> <mysql_executable> <mysql_options>" if scalar(@ARGV) <= 1;
my ($registry_nick_name, $species_name, @other_args) = @ARGV;

my $group_name;
$group_name = shift @other_args if @other_args && ($other_args[0] !~ /mysql/ && $other_args[0] !~ /^-/);

my $mysql_executable = 'mysql';
$mysql_executable = shift @other_args if @other_args && ($other_args[0] =~ /mysql/);

my $ensembl_cvs_root_dir = $ENV{'ENSEMBL_CVS_ROOT_DIR'} || die '$ENSEMBL_CVS_ROOT_DIR is not defined';
my $stored_registry_file = "${ensembl_cvs_root_dir}/reg_${registry_nick_name}.srl";

my $digested_registry;

if (-s $stored_registry_file) {

    require File::Slurp;
    my $bin_data = File::Slurp::read_file($stored_registry_file) or die $!;

    require Sereal::Decoder;
    my $decoder = Sereal::Decoder->new();
    $digested_registry = $decoder->decode($bin_data) || die "Could not load '$stored_registry_file'";

} else {

    warn "Stored registry file '$stored_registry_file' not found. Generating it now.\n";

    $ENV{'CVS_MATT'} || die '$CVS_MATT is not defined';
    my $registry_file = "$ENV{'CVS_MATT'}/.registry/${registry_nick_name}.pl";
    die "Cannot find '$registry_file'" unless -s $registry_file;

    require Bio::EnsEMBL::Registry;
    require Bio::EnsEMBL::ApiVersion;
    my $count = Bio::EnsEMBL::Registry->load_all($registry_file);

    my %dbas = map {$_ => {}} keys %{ $Bio::EnsEMBL::Registry::registry_register{'_SPECIES'} };
    die "No adaptors found !\n" unless scalar(keys %dbas);

    foreach my $dba (@{Bio::EnsEMBL::Registry->get_all_DBAdaptors()}) {
        my $dbc = $dba->dbc;
        $dbas{lc $dba->species}->{lc $dba->group} = [$dbc->host, $dbc->port, $dbc->username, $dbc->password, $dbc->dbname];
    }

    $digested_registry = {
        'aliases'   => $Bio::EnsEMBL::Registry::registry_register{'_ALIAS'},
        'dbas'      => \%dbas,
    };

    # Common and display names are not considered aliases, let's pull them separately
    my %names;

    # Since we need to connect to the databases, let's pool the connections for efficiency
    if (Bio::EnsEMBL::ApiVersion::software_version() >= 66) {
        require Bio::EnsEMBL::Compara::Utils::CoreDBAdaptor;
        Bio::EnsEMBL::Compara::Utils::CoreDBAdaptor->pool_all_DBConnections();
    }

    # Methods to fetch alternative names
    my @method_names = qw(get_common_name get_scientific_name);
    if (Bio::EnsEMBL::ApiVersion::software_version() >= 74) {
        push @method_names, 'get_display_name';
    }

    foreach my $dba (@{Bio::EnsEMBL::Registry->get_all_DBAdaptors()}) {
        next unless $dba->group eq 'core' && $dba->species ne 'Ancestral sequences';
        foreach my $method (@method_names) {
            my $name = $dba->get_MetaContainer->$method();
            if ($name) {
                push @{$names{lc $name}}, lc $dba->species;
            } else {
                #warn "$method on ", $dba->species, " returned undef\n";
            }
        }
    }

    foreach my $name (keys %names) {
        next if $digested_registry->{'aliases'}->{$name};
        next if scalar(@{$names{$name}}) > 1;
        $digested_registry->{'aliases'}->{$name} = $names{$name}->[0];
    }

    require Sereal::Encoder;
    my $encoder = Sereal::Encoder->new({'protocol_version' => 3});

    open(my $fh, '>', $stored_registry_file) or die $!;
    binmode($fh);
    print $fh $encoder->encode($digested_registry);
    close $fh;

}

# Special species name used to trigger building the cached registry
exit if $species_name eq '_';

$species_name = lc $species_name;
#use Data::Dumper;
#print Dumper($digested_registry);
unless ($digested_registry->{'dbas'}->{$species_name}) {
    if (my $alias = $digested_registry->{'aliases'}->{$species_name}) {
        $species_name = $alias;
    } else {
        die "No species named '$species_name' found";
        #use Text::Levenshtein qw(distance);
        #use List::Util;
        #my @allnames = (keys %{ $digested_registry->{'dbas'} }, keys %{ $digested_registry->{'aliases'} });
        #my @alldist = distance($species_name, @allnames);
        #use Data::Dumper;
        #warn Dumper(\@allnames, \@alldist);
        #my @idx = sort {$alldist[$a] <=> $alldist[$b]}  0..(scalar(@allnames)-1);
        #my $best = @allnames[$idx[0]];
        #die "No species named '$species_name' found but $idx[0]=$best";
    }
}

my @possible_groups = keys %{ $digested_registry->{'dbas'}->{$species_name} };
if ($group_name) {
    $group_name = lc $group_name;
    unless ($digested_registry->{'dbas'}->{$species_name}->{$group_name}) {
        die "No group named '$group_name' for species '$species_name'. Use one of: ", join(", ", @possible_groups), "\n";
    }

} else {

    if (scalar(@possible_groups) > 1) {
        die "The registry contains multiple entries for '$species_name': ", join(", ", @possible_groups), "\n";
    }
    $group_name = $possible_groups[0];
}

my ($host, $port, $user, $pass, $dbname) = @{ $digested_registry->{'dbas'}->{$species_name}->{$group_name} };

my @cmd = ($mysql_executable, '--host', $host, '--port', $port, '--user', $user, $dbname, @other_args);
exec @cmd;

