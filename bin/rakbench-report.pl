#!/usr/bin/perl

use warnings;
use strict;
use Data::Dumper;

sub minmax {
  my ($hashref, $val) = @_;
  $hashref->{'min'} = $val if 
    !defined($hashref->{'min'}) || $val < $hashref->{'min'};
  $hashref->{'max'} = $val if 
    !defined($hashref->{'max'}) || $val > $hashref->{'max'};
}

my %info;
my %buildnick;

open(my $IN, "<", $ARGV[0])
  or die "Cannot read $ARGV[0]: $!\n";

while (<$IN>) {
    last if /===rakbench begin /;
    chomp;
    if (m!^(\S+)/RAKBENCH-NICK=(.*)!) { $buildnick{$1} = $2; }
    if (m!^([^\s=]+)=(.*)!)           { $info{$1} = $2; next; }
    if (m!^Mem:\s*(\d+)!)             { $info{'mem'} = $1; next; }
    if (m!^Architecture:\s*(\S+)!)    { $info{'arch'} = $1; next; }
    if (m!^gcc version (\S+)!)        { $info{'gcc'} = $1; next; }
    if (m!^Description:\s*(.*)!)      { $info{'os_desc'} = $1; next; }
}

my %seen;
my (@bench, @build, @trial);
my %mark;
while (<$IN>) {
    if (/^===rakbench run bench=(\S+) build=(\S+) trial=(\S+) ===/) {
        my ($bench, $build, $trial) = ($1, $2, $3);
        $bench =~ s!^(\S*/)?[A-Z]\d+-!!;
        if ($bench eq 'build') {
            while (<$IN>) { last if /^Stage 'pir':/; }
            $bench = 'core.pm';
        }
        push @bench, $bench unless $seen{$bench}++;
        push @build, $build unless $seen{$build}++;
        push @trial, $trial unless $seen{$trial}++;
        while (<$IN>) {
            if (/((\d+):(\d+.\d+)elapsed)/) {
                my $elapsed = $2 * 60 + $3;
                $mark{$bench}{$build}{$trial} = $elapsed;
                minmax($mark{$bench}{$build}, $elapsed);
                minmax($mark{$bench}, $elapsed);
                # print "$bench $build $trial $elapsed\n";
                last;
            }
        }
    }
}
close($IN);

foreach (qw(1 2 3 4)) { push @trial, $_ unless $seen{$_}++ }
foreach (@build) { $buildnick{$_} = $_ unless $buildnick{$_}; }

my $mem = sprintf("%.0fMB", $info{'mem'} / (1024*1024));
print 
  "$info{'hostname'} $info{'id/sys_vendor'} $info{'id/product_name'} ",
  "$info{'arch'} $mem ",
  "$info{'os_desc'} gcc=$info{'gcc'}\n";
print "$info{'rundate'}\n";

my $build0 = $build[0];
printf "%-26s", "Version";
foreach (@trial) { print "     T$_ "; }
print "    Fastest  vs base\n";
print '-' x 78;
print "\n";

foreach my $bench (@bench) {
    no warnings;
    print "$bench:\n";
    my $min0 = $mark{$bench}{$build0}{'min'} || 1;
    my $markfmt = $mark{$bench}{'max'} < 10 ? '%8.2f' : '%8.1f';
    foreach my $build (@build) {
        printf "  %-24s", $buildnick{$build};
        foreach my $trial (@trial) {
            my $mark = $mark{$bench}{$build}{$trial};
            my $out = defined($mark) ? sprintf($markfmt, $mark) : '';
            printf "%8s", $out;
        }
        my $min = $mark{$bench}{$build}{'min'};
        printf "   $markfmt%8.1f%%", $min, ($min/$min0)*100;
        printf "\n";
    }
    printf "\n";
}

print '-' x 78;
print "\n";

print "\n";
print "Build information:\n";
my @infokeys = sort keys %info;
foreach my $build (@build) {
    print "  $buildnick{$build}: Rakudo $info{$build.'/rakudo-version'}, Parrot $info{$build.'/parrot_config-git_describe'}\n";
    my $note = "    - ";
    foreach my $key (grep /^$build\/RAKBENCH-NOTE/ , @infokeys) {
        print "$note$info{$key}\n";
    }
}
