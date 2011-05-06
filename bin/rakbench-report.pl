#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;

my %seen;
my (@bench, @rakudo, @trial);
my %mark;
while (<>) {
    if (/^=== (\S+) (\S+) trial (\S+) ===/) {
        my ($bench, $rakudo, $trial) = ($1, $2, $3);
        push @bench, $bench unless $seen{$bench}++;
        push @rakudo, $rakudo unless $seen{$rakudo}++;
        push @trial, $trial unless $seen{$trial}++;
        if ($bench eq 'build') {
            while (<>) { last if /^Stage 'pir':/; }
        }
        while (<>) {
            if (/((\d+):(\d+.\d+)elapsed)/) {
                my $elapsed = $2 * 60 + $3;
                $mark{$bench}{$rakudo}{$trial} = $elapsed;
                $mark{$bench}{$rakudo}{'min'} = $elapsed
                    if !defined($mark{$bench}{$rakudo}{'min'})
                       || $elapsed < $mark{$bench}{$rakudo}{'min'};
                # print "$bench $rakudo $trial $elapsed\n";
                last;
            }
        }
    }
}

my %rakid;
foreach my $rakudo (@rakudo) {
    $rakid{$rakudo} = $rakudo;
    if (open(my $rakfh, "<", "$rakudo/RAKBENCH-ID")) {
        $_ = <$rakfh>; chomp $_; $rakid{$rakudo} = $_;
        close($rakfh);
    }
}

foreach (qw(1 2 3 4)) { push @trial, $_ unless $seen{$_}++ }


my $rak0 = $rakudo[0];
printf "%-26s", "Version";
foreach (@trial) { print "     T$_ "; }
print "    Fastest  vs base\n";
print '-' x 78;
print "\n";

foreach my $bench (@bench) {
    print "$bench:\n";
    my $min0 = $mark{$bench}{$rak0}{'min'};
    foreach my $rakudo (@rakudo) {
        printf "  %-24s", $rakid{$rakudo};
        foreach my $trial (@trial) {
            my $mark = $mark{$bench}{$rakudo}{$trial};
            my $out = defined($mark) ? sprintf("%8.1f", $mark) : '';
            printf "%8s", $out;
        }
        my $min = $mark{$bench}{$rakudo}{'min'};
        printf "%11.1f%8.1f%%", $min, ($min/$min0)*100;
        printf "\n";
    }
    printf "\n";
}
