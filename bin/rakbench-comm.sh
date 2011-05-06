#!/bin/sh
####
## rakbench-comm.sh
##   Time needed to run the common spectests (in src/commontest.data)
##   on multiple releases.  Because running spectests takes so long,
##   this script is not included by default in rakudo-run.sh, and
##   it defaults to running only two trials per release.
####

TRIALS="${TRIALS:-1 2}"
RELEASES="${RELEASES:-$(echo rakudo-201?.??)}"

for trial in $TRIALS
do
  for rel in $RELEASES
  do
    echo "=== commontest $rel trial $trial ==="
    date
    ( cd $rel;
      HARNESS_NOTTY=1 /usr/bin/time /usr/bin/perl t/harness --fudge --keep-exit-code --icu=1 --tests-from-file=../src/commontest.data
    )
    date
  done
done

