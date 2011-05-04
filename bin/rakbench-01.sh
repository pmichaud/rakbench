#!/bin/sh
####
## rakbench-1.sh:
##   Times needed to build various rakudo components, as well
##   as rakudo itself.
####

RELEASES="2011.01 2011.02 2011.03 2011.04"

for trial in 1 2 3 4
do
  for rel in $RELEASES
  do
    echo "=== build rakudo-$rel trial $trial ==="
    date
    ( cd rakudo-$rel; make clean; time make )
    date
  done
done

