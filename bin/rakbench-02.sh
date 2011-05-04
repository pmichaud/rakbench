#!/bin/sh
####
## rakbench-2.sh:
##   Time needed to run several of the t/spec/S32-trig tests.
####

RELEASES="2011.01 2011.02 2011.03 2011.04"

for trial in 1 2 3 4
do
  for rel in $RELEASES
  do
    echo "=== S32-trig rakudo-$rel trial $trial ==="
    date
    ( cd rakudo-$rel;
      /usr/bin/time /usr/bin/perl t/harness --fudge --keep-exit-code --icu=1 --verbosity=1 t/spec/S32-trig/sin.t t/spec/S32-trig/atan2.t t/spec/S32-trig/tanh.t
    )
    date
  done
done

