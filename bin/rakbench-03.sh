#!/bin/sh
####
## rakbench-3.sh:
##   Time needed to run the t/spec/S32-trig/atan2.t test
####

TRIALS="${TRIALS:-1 2 3 4}"
RELEASES="${RELEASES:-$(echo rakudo-201?.??)}"

for trial in $TRIALS
do
  for rel in $RELEASES
  do
    echo "=== atan2 $rel trial $trial ==="
    date
    ( cd $rel;
      /usr/bin/time /usr/bin/perl t/harness --fudge --keep-exit-code --icu=1 --verbosity=1 t/spec/S32-trig/atan2.t 
    )
    date
  done
done

