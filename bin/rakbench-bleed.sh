#!/bin/sh

[ -d rakudo-bleed ] || 
  { echo "No rakudo-bleed directory...aborting"; exit 1; }

cd rakudo-bleed
[ -f RAKBENCH ] ||
  echo "NICK=rakudo-bleed (gms)" >RAKBENCH
git pull
git checkout master
rm -rf parrot_install
(
  cd parrot &&
    make realclean &&
    perl Configure.pl --optimize --gc=gms --prefix=../parrot_install &&
    make &&
    make install
) &&
  perl Configure.pl --makefile-timing --parrot-config=parrot_install/bin/parrot_config &&
  make testable &&
  echo "rakudo-bleed complete"


