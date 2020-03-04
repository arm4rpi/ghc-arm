#!/bin/bash

set -e

# 函数中做判断要有完整的 if else 结构，要有返回值，否则将受 set -e 影响
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
	umount -l proc
	umount -f proc
}

function _down() {
	version="$1"
	download http://cdimage.ubuntu.com/ubuntu-base/releases/$version/release/ubuntu-base-$version-base-armhf.tar.gz tmp "ubuntu-arm.tar.gz"
	download http://cdimage.ubuntu.com/ubuntu-base/releases/$version/release/ubuntu-base-$version-base-arm64.tar.gz tmp "ubuntu-aarch64.tar.gz"
}

function run() {
	ARCH=$1
	cd rootfs 
	tar xvf ../tmp/ubuntu-$ARCH.tar.gz
	cp /etc/resolv.conf etc/
	cp /usr/bin/qemu-$ARCH-static usr/bin
	cp $SCRIPTDIR/ghc.sh .

	_mount
	chroot . /ghc.sh
	_umount
}

SCRIPTDIR=`cd $(dirname $0);pwd`
[ -d rootfs ] && rm -fr rootfs
_mkdir tmp
_mkdir rootfs

apt-get update
apt-get install -y qemu-user-static aria2 xz-utils curl


[ $# -lt 1 ] && echo "$0 version arch" && exit 1

_down "$1"

if [ "$2"x == "arm"x ];then
	echo "RUN ARM"
	run arm
else
	echo "RUN AARCH64"
	run aarch64
fi
