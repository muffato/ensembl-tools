#!/usr/bin/env perl
use strict;
use warnings;

use Bio::EnsEMBL::Registry;
use Bio::AlignIO;

die "Usage $0 query_species query_chromosome query_start query_end [coords|align|debug]\n" if scalar(@ARGV) < 4;

my %modes = map {$_=>1} qw(coords align debug);
my $mode = $ARGV[4] || 'coords';
die "Unrecognized mode '$mode'" unless $modes{$mode};

## Load the registry automatically
my $reg = "Bio::EnsEMBL::Registry";
$reg->load_registry_from_url('mysql://anonymous@ensembldb.ensembl.org');

# Get the Compara Adaptor for MethodLinkSpeciesSet
my $method_link_species_set_adaptor = Bio::EnsEMBL::Registry->get_adaptor("Multi", "compara", "MethodLinkSpeciesSet");

# Get the method_link_species_set for the alignments
my @method_links = qw(LASTZ_NET BLASTZ_NET TRANSLATED_BLAT_NET);
my $methodLinkSpeciesSet;
foreach my $ml (@method_links) {
    $methodLinkSpeciesSet = $method_link_species_set_adaptor->fetch_by_method_link_type_registry_aliases($ml, [$ARGV[0]]);
    last if $methodLinkSpeciesSet;
}
die "Could not find a self alignment for $ARGV[0] (tried @method_links)\n" unless $methodLinkSpeciesSet;
warn $methodLinkSpeciesSet->toString(), "\n";

# Define the start and end positions for the alignment
my ($query_start, $query_end) = ($ARGV[2], $ARGV[3]);

# Get the query *core* Adaptor for Slices
my $query_slice_adaptor = Bio::EnsEMBL::Registry->get_adaptor($ARGV[0], "core", "Slice");

# Get the slice corresponding to the region of interest
my $query_slice = $query_slice_adaptor->fetch_by_region(undef, $ARGV[1], $query_start, $query_end);

# Get the Compara Adaptor for GenomicAlignBlocks
my $genomic_align_block_adaptor = Bio::EnsEMBL::Registry->get_adaptor("Multi", "compara", "GenomicAlignBlock");

# The fetch_all_by_MethodLinkSpeciesSet_Slice() returns a ref. to an array of GenomicAlingBlock objects 
my $all_genomic_align_blocks = $genomic_align_block_adaptor->fetch_all_by_MethodLinkSpeciesSet_Slice($methodLinkSpeciesSet, $query_slice);

# set up an AlignIO to format SimpleAlign output
my $alignIO = Bio::AlignIO->newFh(-interleaved => 0,
                                  -fh => \*STDOUT,
                                  -format => 'clustalw',
                                  -idlength => 20);

# print the restricted alignments
foreach my $genomic_align_block( @{ $all_genomic_align_blocks }) {
    my $restricted_gab = $genomic_align_block->restrict_between_reference_positions($query_start, $query_end);

    printf("Alignment block %s:\n", $genomic_align_block->dbID);
    if ($mode eq 'align') {
	print $alignIO $restricted_gab->get_SimpleAlign;

    } elsif ($mode eq 'coords') {
        foreach my $genomic_align ( @{ $restricted_gab->get_all_GenomicAligns() } ) {
            printf("%s %s:%d-%d\n", $genomic_align->genome_db->name, $genomic_align->dnafrag->name, $genomic_align->dnafrag_start, $genomic_align->dnafrag_end);
        }

    } else {
        print "/original\n";
        print $genomic_align_block->toString(), "\n";
        foreach my $g (@{$genomic_align_block->get_all_GenomicAligns()}) {
            print $g->toString(), "\n";
        }
        print "/restricted\n";
        print $restricted_gab->toString(), "\n";
        foreach my $g (@{$restricted_gab->get_all_GenomicAligns()}) {
            print $g->toString(), "\n";
        }

    }
    print "\n";
}

