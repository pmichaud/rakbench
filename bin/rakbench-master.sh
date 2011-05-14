#!/bin/sh

[ -d rakudo-master ] || 
  { echo "No rakudo-master directory...aborting"; exit 1; }

cd rakudo-master
PARROT_INSTALL_DIR=$(readlink -f parrot_install)
[ -f RAKBENCH ] ||
  echo "NICK=rakudo-master (gms)" >RAKBENCH
git pull
git checkout master
rm -rf $PARROT_INSTALL
perl Configure.pl --gen-parrot --makefile-timing &&
  make &&
  make t/spec &&
  echo "rakudo-master complete"


