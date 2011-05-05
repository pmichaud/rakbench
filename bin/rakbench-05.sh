#!/bin/sh
####
## rakbench-05.sh:
##   Time needed to execute "-e 1" (i.e., Rakudo startup time)
####

TRIALS="${TRIALS:-1 2 3 4}"
RELEASES="${RELEASES:-$(echo rakudo-201?.??)}"

for trial in $TRIALS
do
  for rel in $RELEASES
  do
    echo "=== startup $rel trial $trial ==="
    date
    ( cd $rel;
      /usr/bin/time ./perl6 -e 1
    )
    date
  done
done

