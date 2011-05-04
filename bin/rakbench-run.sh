#!/bin/bash

ARCH=$(uname -i)
mkdir -p log

LOGFILE=$(date +log/rakbench-$HOSTNAME-$ARCH-%Y%m%d%H%M.log)

(for t in bin/rakbench-??.sh
do
  echo "== $t start =="
  sh $t
  echo "== $t end =="
done) |& tee $LOGFILE
