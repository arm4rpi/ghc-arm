#!/bin/sh

set -e

apt-get update
apt-get install -y haskell-platform xz-utils git curl
rm -fr /var/cache/apt/*

exit $?
