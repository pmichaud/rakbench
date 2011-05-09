#!/bin/bash

for build in "$@"
do
  RAKBENCH=$build/RAKBENCH
  [ -f $RAKBENCH ] && 
    { echo "$RAKBENCH exists...skipping"; continue; }
  echo "Creating $RAKBENCH..."
  GC_TYPE=$($build/parrot_install/bin/parrot_config gc_type)
  GC_TYPE=${GC_TYPE/*no such key*/unk}
  echo "NICK=$(<$build/VERSION)/$(<$build/parrot/VERSION) (${GC_TYPE,,})" > $RAKBENCH
  echo "# NOTE=Additional note(s) here" >> $RAKBENCH
  cat $RAKBENCH
done
