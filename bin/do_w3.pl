#!/usr/bin/env perl

use strict;
use warnings;

use Cwd;
use File::Basename;
use Sys::Hostname;

if ($0 =~ /w3_([^\/]*)$/) {
    my $command = $1;
    my $d = cwd();
    if ($d =~ /\/ens_adm30\/workspace\/src\/([^\/]*)/) {
        my $dev_name = $1;
        my $hostname = hostname;
        my $username = getpwuid( $< );
        $username =~ s/ens_adm/w3_ens/;
        print join(' ', 'ssh', $username.'@'.$hostname, 'workspace/src/'.$dev_name.'/ensembl-webcode/ctrl_scripts/'.$command, @ARGV), "\n";
        exec('ssh', $username.'@'.$hostname, 'workspace/src/'.$dev_name.'/ensembl-webcode/ctrl_scripts/'.$command, @ARGV);
    } else {
        die "Cannot recognize the path '$d'\n";
    }
} else {
    die "Cannot recognized command in '$0'\n";
}

