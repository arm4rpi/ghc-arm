#!/bin/bash


function download() {
	out=""
	[ "$3"x != ""x ] && out="--out=$3"
	[ ! -f "$2/$3" ] && \
	aria2c -x 16 "$1" --dir="$2" $out
}

function _mkdir() {
	[ ! -d $1 ] && mkdir -p $1
}

function _rmmkdir() {
	[ -d $1 ] && rm -fr $1 && mkdir -p $1
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

function arm() {
	cd rootfs 
	tar xvf ../tmp/alpine-minirootfs-3.9.0-armhf.tar.gz
	cp /etc/resolv.conf etc
	cp /usr/bin/qemu-arm-static usr/bin

	_mount
	chroot . /ghc.sh
	find ./ -type f |grep "ghc" |xargs tar Jcvf ../release/ghc-8.6.3-armv7-alpine9.0.tar.xz
	_umount
}

function aarch64() {
	cd rootfs 
	tar xvf ../tmp/alpine-minirootfs-3.9.0-aarch64.tar.gz
	cp /etc/resolv.conf etc
	cp /usr/bin/qemu-aarch64-static usr/bin

	_mount
	chroot . /ghc.sh
	find ./ -type f |grep "ghc" |xargs tar Jcvf ../release/ghc-8.6.2-aarch64-alpine9.0.tar.xz
	_umount
}


yum install -y aria2

download https://github.com/multiarch/qemu-user-static/releases/download/v4.2.0-4/qemu-aarch64-static /usr/bin
download https://github.com/multiarch/qemu-user-static/releases/download/v4.2.0-4/qemu-arm-static /usr/bin
download http://dl-cdn.alpinelinux.org/alpine/v3.9/releases/aarch64/alpine-minirootfs-3.9.0-aarch64.tar.gz tmp
download http://dl-cdn.alpinelinux.org/alpine/v3.9/releases/armhf/alpine-minirootfs-3.9.0-armhf.tar.gz tmp
download https://github.com/commercialhaskell/ghc/releases/download/ghc-8.6.3-release/ghc-8.6.3-armv7-deb8-linux.tar.xz tmp
download https://github.com/commercialhaskell/ghc/releases/download/ghc-8.6.2-release/ghc-8.6.2-aarch64-deb8-linux.tar.xz tmp


if [ "$1"x == "arm"x ];then
	_rmmkdir rootfs
	cp tmp/ghc-8.6.3-armv7-deb8-linux.tar.xz rootfs/ghc.tar.xz
	arm
else
	_rmmkdir rootfs
	cp ghc-8.6.2-aarch64-deb8-linux.tar.xz rootfs/ghc.tar.gz
	aarch64
fi
