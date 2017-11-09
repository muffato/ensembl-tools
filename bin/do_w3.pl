#!/usr/bin/env perl

use strict;
use warnings;

use Cwd;
use File::Basename;
use Sys::Hostname;

sub run_ssh_command {
    my $hostname = hostname;
    my $username = getpwuid( $< );
    $username =~ s/ens_adm/w3_ens/;
    print join(' ', 'ssh', $username.'@'.$hostname, @_), "\n";
    exec('ssh', '-F', '/dev/null', $username.'@'.$hostname, @_);
}

if ($0 =~ /w3_([^\/]*)$/) {
    my $command = $1;
    if ($command eq 'shell') {
        run_ssh_command(@ARGV);
        exit;
    }
    my $d = cwd();
    if ($d =~ /\/ens_adm30\/workspace\/src\/([^\/]*)/) {
        my $dev_name = $1;
        my $script = 'workspace/src/'.$dev_name.'/ensembl-webcode/ctrl_scripts/'.$command;
        run_ssh_command($script, @ARGV);
    } else {
        die "Cannot recognize the path '$d'\n";
    }
} else {
    die "Cannot recognized command in '$0'\n";
}

