#!/bin/sh

for rel in rakudo-2011.01 rakudo-2011.02 rakudo-2011.03 rakudo-2011.04
do
  bin/rakbench-build.sh $rel
done

