#!/bin/sh

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
apk update
apk add make libc-dev pcre-dev libc6-compat ncurses5-libs gmp-dev llvm zlib-dev gcc perl g++
ln -s /usr/lib/libncurses.so.5 /usr/lib/libtinfo.so.5

_repoEdge
apk add numactl-dev

ARCH=`uname -m`

tar xvf /ghc.tar.xz
if [ "$ARCH"x == "aarch64"x ];then
	cd /ghc-8.6.2
   ./configure
	make install
else
	cd /ghc-8.6.3
	./configure
	make install
fi

exit 0
