#!/bin/bash

# This script updates any of the build directories (given as
# arguments to the script) to use Parrot's master HEAD.
# Example:
#    bin/build-parrot-head.sh rakudo-bleed rakudo-2011.04-head ...

START_DIR=$PWD
set -e
for build in $*
do
  cd $START_DIR
    [ -f $build/RAKBENCH ] ||
      { echo "Cannot find $build/RAKBENCH... abort"; exit 1; }
  BUILD_DIR=$(readlink -f $build)
  cd $BUILD_DIR
    [ -d parrot ] || git clone git@github.com:parrot/parrot.git
    rm -rf parrot_install
  cd $BUILD_DIR/parrot
    git pull
    git checkout master
    make realclean || true
    perl Configure.pl --optimize --gc=gms --prefix=$BUILD_DIR/parrot_install
    make
    make install
  cd $BUILD_DIR
    make realclean || true
    perl Configure.pl --makefile-timing --parrot-config=parrot_install/bin/parrot_config
    make t/spec
  echo "$build/parrot complete"
  echo "Don't forget to run 'make' in $build if needed"
done
