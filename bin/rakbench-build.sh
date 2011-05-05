#!/bin/sh
##########
# rakbench-build.sh - build a single Rakudo release from its tarball
#
# Usage:
#    bin/rakbench-build.sh release_name [dir]
#
# Description:
#    This script can be used to quickly download and build a Rakudo
#    release from its tarball source.  The script first checks the
#    src/ directory to see if the tarball is already available;
#    if not, the tarball is downloaded from GitHub.  The tarball
#    is then unpacked into the directory given by [dir] (or the
#    release name if [dir] isn't specified).  The resulting
#    extraction is then pre-built using the --makefile-timing
#    and --gen-parrot options to Rakudo's Configure.pl.
#
# Examples:
#    bin/rakbench-build.sh rakudo-2011.01
#    bin/rakbench-build.sh rakudo-2011.04 otherdir
###

RELEASE=$1
[ -n "$RELEASE" ] || 
  { echo "Usage: $0 release_name [dir]"; exit 1; }

RAKUDO_DIR=${2:-$RELEASE}

[ -e "$RAKUDO_DIR" ] && 
  { echo "$0: $RAKUDO_DIR already exists... aborting"; exit 1; }

RAKUDO_TGZ="$RELEASE.tar.gz"
[ -f src/$RAKUDO_TGZ ] || 
  wget --no-check-certificate -O src/$RAKUDO_TGZ https://github.com/downloads/rakudo/rakudo/$RAKUDO_TGZ 
tar --transform "s/[^\\/]*/$RAKUDO_DIR/" --show-stored-names -xvzf src/$RAKUDO_TGZ
( cd $RAKUDO_DIR; perl Configure.pl --makefile-timing --gen-parrot )

