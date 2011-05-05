#!/bin/sh
####
## rakbench-1.sh:
##   Times needed to build various rakudo components, as well
##   as rakudo itself.
####

TRIALS="${TRIALS:-1 2 3 4}"
RELEASES="${RELEASES:-$(echo rakudo-201?.??)}"

for trial in $TRIALS
do
  for rel in $RELEASES
  do
    echo "=== build $rel trial $trial ==="
    date
    ( cd $rel; make clean; time make )
    date
  done
done

