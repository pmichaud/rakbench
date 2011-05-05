#!/bin/sh
####
## rakbench-04.sh:
##   Time needed to run t/spec/S05-mass/rx.t
####

TRIALS="${TRIALS:-1 2 3 4}"
RELEASES="${RELEASES:-$(echo rakudo-201?.??)}"

for trial in $TRIALS
do
  for rel in $RELEASES
  do
    echo "=== rx.t $rel trial $trial ==="
    date
    ( cd $rel;
      /usr/bin/time /usr/bin/perl t/harness --fudge --keep-exit-code --icu=1 --verbosity=1 t/spec/S05-mass/rx.t
    )
    date
  done
done

