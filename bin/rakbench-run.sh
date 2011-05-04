#!/bin/sh

ARCH=$(uname -i)
mkdir -p log

LOGFILE=$(date +log/rakbench-$HOSTNAME-$ARCH-%Y%m%d%H%m.log)

for t in bin/rakbench-??.sh
do
  echo "== $t start ==" >>$LOGFILE
  sh $t >>$LOGFILE 2>&1
  echo "== $t end ==" >>$LOGFILE
done
