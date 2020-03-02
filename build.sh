#!/bin/bash

function download() {
	[ ! -f "$2/$3" ] && \
	aria2c -x 16 "$1" --dir="$2" --out="$3"
}

function _mkdir() {
	[ ! -d $1 ] && mkdir -p $1
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
	tar xvf ../tmp/ubuntu-$ARCH.tar.gz
	cp /etc/resolv.conf etc/
	cp /usr/bin/qemu-$ARCH-static usr/bin
	cp ../ghc.sh .
	cp ../stack.sh root

	_mount
	chroot . /ghc.sh
	_umount
}

[ -d rootfs ] && rm -fr rootfs
_mkdir tmp
_mkdir rootfs

apt-get update
apt-get install -y qemu-user-static aria2 xz-utils

download http://cdimage.ubuntu.com/ubuntu-base/releases/19.10/release/ubuntu-base-19.10-base-armhf.tar.gz tmp "ubuntu-arm.tar.gz"
download http://cdimage.ubuntu.com/ubuntu-base/releases/19.10/release/ubuntu-base-19.10-base-arm64.tar.gz tmp "ubuntu-aarch64.tar.gz"

if [ "$1"x == "arm"x ];then
	echo "RUN ARM"
	run arm
else
	echo "RUN AARCH64"
	run aarch64
fi
