#!/bin/sh
####
## rakbench-2.sh:
##   Time needed to run the t/spec/S32-trig/sin.t test
####

TRIALS="${TRIALS:-1 2 3 4}"
RELEASES="${RELEASES:-$(echo rakudo-201?.??)}"

for trial in $TRIALS
do
  for rel in $RELEASES
  do
    echo "=== sin.t $rel trial $trial ==="
    ( cd $rel;
      /usr/bin/time /usr/bin/perl t/harness --fudge --keep-exit-code --icu=1 --verbosity=1 t/spec/S32-trig/sin.t 
    )
    date
  done
done

