all: build

build:
	drone exec --trusted --secret-file /tmp/ghc-arm-secret.txt 
