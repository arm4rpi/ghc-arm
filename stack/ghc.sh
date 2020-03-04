#!/bin/bash

set -e

apt-get update
apt-get install -y build-essential llvm-6.0 libtinfo5 libncurses5-dev libgmp-dev perl git aria2 xz-utils curl

ARCH=`uname -m`

ls -l /
tar xvf /ghc.tar.xz
rm -f ghc.tar.xz
if [ "$ARCH"x == "aarch64"x ];then
	apt-get install -y libnuma1 numactl libnuma-dev
	cd /ghc-8.6.2
   ./configure
	make install
	cd ../
	rm -fr ghc-8.6.2
else
	cd /ghc-8.6.3
	./configure
	make install
	cd ../
	rm -fr ghc-8.6.3
fi

/root/stack.sh

exit $?
