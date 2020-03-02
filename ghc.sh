#!/bin/sh

set -e

function _repo() {
	cat > /etc/apk/repositories <<EOF
http://mirrors.ustc.edu.cn/alpine/v3.9/main
http://mirrors.ustc.edu.cn/alpine/v3.9/community
EOF
}

function _repoEdge() {
		cat > /etc/apk/repositories <<EOF
http://mirrors.ustc.edu.cn/alpine/v3.9/main
http://mirrors.ustc.edu.cn/alpine/v3.9/community
http://mirrors.ustc.edu.cn/alpine/edge/main
http://mirrors.ustc.edu.cn/alpine/edge/community
EOF
}

_repo

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
