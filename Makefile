all: build aarch64 arm

build:
	docker build -t pandoc-ghc:latest .
arm:
	docker run --privileged --rm -it -v $(shell pwd)/rootfs:/ghc/rootfs -v $(shell pwd)/release:/ghc/release -v $(shell pwd)/tmp:/ghc/tmp pandoc-ghc:latest arm
aarch64:
	docker run --privileged --rm -it -v $(shell pwd)/rootfs:/ghc/rootfs -v $(shell pwd)/release:/ghc/release -v $(shell pwd)/tmp:/ghc/tmp pandoc-ghc:latest
