#!/bin/sh

set -e

apt-get update
apt-get install -y ghc xz-utils llvm-6.0 aria2 git curl
/root/stack.sh
rm -fr /var/cache/apt/*

exit $?
