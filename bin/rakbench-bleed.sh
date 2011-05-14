#!/bin/sh

[ -d rakudo-bleed ] || 
  { echo "No rakudo-bleed directory...aborting"; exit 1; }

cd rakudo-bleed
PARROT_INSTALL_DIR=$(readlink -f parrot_install)
[ -f RAKBENCH ] ||
  echo "NICK=rakudo-bleed (gms)" >RAKBENCH
git pull
git checkout master
rm -rf $PARROT_INSTALL
(
  [ -d parrot ] || git clone git@github.com:parrot/parrot.git
  cd parrot &&
    git pull &&
    git checkout master &&
    make realclean;
    perl Configure.pl --optimize --gc=gms --prefix=$PARROT_INSTALL_DIR &&
    make &&
    make install
) &&
  perl Configure.pl --makefile-timing --parrot-config=parrot_install/bin/parrot_config &&
  make t/spec &&
  echo "rakudo-bleed complete"


