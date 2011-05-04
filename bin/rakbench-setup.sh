#!/bin/sh
RELEASES="2011.01 2011.02 2011.03 2011.04"

mkdir -p src

for rel in $RELEASES
do
  RAKUDO_DIR=rakudo-$rel
  RAKUDO_TGZ=rakudo-$rel.tar.gz
  [ -f src/$RAKUDO_TGZ ] || wget --no-check-certificate -O src/$RAKUDO_TGZ https://github.com/downloads/rakudo/rakudo/$RAKUDO_TGZ 
  rm -rf $RAKUDO_DIR
  tar xvfz src/$RAKUDO_TGZ
  ( cd $RAKUDO_DIR; perl Configure.pl --makefile-timing --gen-parrot )
done

