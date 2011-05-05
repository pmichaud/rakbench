#!/bin/bash

ARCH=$(uname -i)
mkdir -p log 

LOGFILE=$(date +log/$HOSTNAME-$ARCH-%Y%m%d%H%M.log)

(
# output some statistics
uname -a
grep MemTotal /proc/meminfo
date
# run the suite
for t in bin/rakbench-??.sh
do
  echo "== $t start =="
  date
  sh $t
  date
  echo "== $t end =="
done
) |& tee $LOGFILE
