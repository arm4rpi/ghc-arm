FROM debian:buster

WORKDIR /ghc
COPY rootfs ./rootfs
RUN apt update && apt install -y qemu-user-static && rm -fr /var/cache/apt/*
