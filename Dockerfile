FROM debian:buster

WORKDIR /ghc
COPY rootfs ./rootfs
RUN apt-get update && apt-get install -y curl && rm -fr /var/cache/apt/*
