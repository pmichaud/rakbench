#!/bin/bash

ARCH=$(uname -i)
LOGFILE=$(date -u +log/$HOSTNAME-$ARCH-%Y%m%d%H%M.log)
export SPECTEST="/usr/bin/perl t/harness --fudge --keep-exit-code"
export RAKBENCH_DIR=$PWD

if [ "$1" ] 
then
  for arg in "$@"
  do
    [ -d $arg ] && BUILDLIST="${BUILDLIST:+$BUILDLIST }$arg" && continue
    [ -f $arg ] && BENCHLIST="${BENCHLIST:+$BENCHLIST }$arg" && continue
    echo "Unrecognized argument $arg"
    exit 1
  done
fi

BENCHLIST=${BENCHLIST:-$(echo bench/B*)}
BUILDLIST=${BUILDLIST:-$(echo rakudo-2011*)}

function isodate() { date -u +"%Y-%m-%dT%H:%M:%SZ"; }

function sysinfo() {
  echo "hostname=$HOSTNAME"
  uname -a
  free -b
  for id in sys_vendor product_name
  do
    [ -r /sys/devices/virtual/dmi/id/$id ] &&
      echo "id/$id=$(</sys/devices/virtual/dmi/id/$id)"
  done
  lscpu
  lsb_release -a
  gcc -v
}


function buildinfo() {
  for build in $BUILDLIST
  do
    [ -r $build/RAKBENCH-ID ] && 
      echo "$build/RAKBENCH-ID=$(< $build/RAKBENCH-ID)"
  done
}


[ -f $LOGFILE ] &&
  { echo "$LOGFILE already exists... aborting"; exit 1; }

(
  echo "===rakbench runinfo ==="
  echo "rakbench-version=001"
  echo "rundate=$(isodate)"
  echo "BENCHLIST=$BENCHLIST"
  echo "BUILDLIST=$BUILDLIST"
  sysinfo
  buildinfo
  echo "===rakbench begin ==="
  for bench in $BENCHLIST
  do
    BENCH=$(readlink -f $bench)
    BENCHTRIAL=$(perl -ne '/Default-Trials: (\S+)/ && print $1' $BENCH)
    TRIALLIST=$(seq 1 ${BENCHTRIAL:-4})
    echo $TRIALLIST
    for trial in $TRIALLIST
    do
      for build in $BUILDLIST
      do
        echo "===rakbench run bench=$bench build=$build trial=$trial ==="
        isodate
        case $bench in
          *.p6)
            echo "/usr/bin/time ./perl6 $BENCH"
            (cd $build; /usr/bin/time ./perl6 $BENCH)
            ;;
          *)
            (cd $build; $BENCH)
            ;;
        esac
        isodate
      done
    done
  done

  echo "===rakbench end date=$(isodate) ==="
) |& tee $LOGFILE

