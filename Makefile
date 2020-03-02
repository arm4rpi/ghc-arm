all: aarch64 arm
aarch64: build-aarch64 docker-aarch64
arm: build-arm docker-arm

build-aarch64:
	drone exec --trusted --pipeline build-aarch64
docker-aarch64:
	drone exec --secret-file /tmp/ghc-arm-secret.txt --pipeline docker-aarch64
build-arm:
	drone exec --trusted --pipeline build-arm
docker-arm:
	drone exec --secret-file /tmp/ghc-arm-secret.txt --pipeline docker-arm
