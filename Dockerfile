FROM debian:buster

RUN sed -r -i 's/security.debian.org|deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN apt-get update && apt-get install -y qemu-user-static aria2 xz-utils
WORKDIR /ghc
ADD build.sh .
ADD ghc.sh .
ENTRYPOINT ["/ghc/build.sh"]
