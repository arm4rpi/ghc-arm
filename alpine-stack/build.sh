#!/bin/bash

set -e

function download() {
	[ ! -f "$2/$3" ] && \
	aria2c -x 16 "$1" --dir="$2" --out="$3" || return 0
}

function _mkdir() {
	[ ! -d $1 ] && mkdir -p $1 || return 0
}

function _mount() {
	mount -t devtmpfs devtmpfs dev
	mount -t devpts devpts dev/pts
	mount -t sysfs sysfs sys
	mount -t tmpfs tmpfs tmp
	mount -t proc proc proc
}

function _umount() {
	umount dev/pts
	umount dev
	umount sys
	umount tmp
	umount proc
}

function run() {
	ARCH=$1
	cd rootfs 
	tar xvf ../tmp/alpine-$ARCH.tar.gz
	cp /etc/resolv.conf etc/
	cp /usr/bin/qemu-$ARCH-static usr/bin
	cp $SCRIPTDIR/ghc.sh .
	cp $SCRIPTDIR/stack.sh root

	_mount
	chroot . /ghc.sh
	_umount
}

SCRIPTDIR=`cd $(dirname $0);pwd`
[ -d rootfs ] && rm -fr rootfs
_mkdir tmp
_mkdir rootfs

apt-get update
apt-get install -y qemu-user-static aria2 xz-utils

download http://dl-cdn.alpinelinux.org/alpine/v3.9/releases/aarch64/alpine-minirootfs-3.9.0-aarch64.tar.gz tmp "alpine-aarch64.tar.gz"
download https://github.com/commercialhaskell/ghc/releases/download/ghc-8.6.2-release/ghc-8.6.2-aarch64-deb8-linux.tar.xz tmp "ghc-aarch64.tar.xz"

cp tmp/ghc-aarch64.tar.xz rootfs/ghc.tar.xz
echo "RUN AARCH64"
run aarch64
