#!/bin/sh

set -e

function _repoEdge() {
		cat >> /etc/apk/repositories <<EOF
http://dl-cdn.alpinelinux.org/alpine/edge/main
http://dl-cdn.alpinelinux.org/alpine/edge/community
EOF
}

apk update
apk add make libc-dev pcre-dev libc6-compat ncurses5-libs gmp-dev llvm zlib-dev gcc perl g++ git aria2 xz
ln -s /usr/lib/libncurses.so.5 /usr/lib/libtinfo.so.5


ARCH=`uname -m`

ls -l /
tar xvf /ghc.tar.xz
rm -f ghc.tar.xz
if [ "$ARCH"x == "aarch64"x ];then
	_repoEdge
	apk update
	apk add numactl-dev
	sed -i '/edge/d' /etc/apk/repositories

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

exit $?
