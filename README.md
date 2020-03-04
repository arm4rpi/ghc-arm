# ghc-arm

[![Build Status](https://ci.annhe.net/api/badges/arm4rpi/ghc-arm/status.svg)](https://ci.annhe.net/arm4rpi/ghc-arm) ![GHC Arm](https://github.com/arm4rpi/ghc-arm/workflows/GHC%20Arm/badge.svg)

use for pandoc ci. available tag

```
ann17/pandoc-ghc-arm:cabal-ghc8.6.5
ann17/pandoc-ghc-arm:cabal-ghc8.0.2
ann17/pandoc-ghc-arm:statck-ghc8.6.3
ann17/pandoc-ghc-aarch64:cabal-ghc8.6.5
ann17/pandoc-ghc-aarch64:cabal-ghc8.0.2
ann17/pandoc-ghc-aarch64:statck-ghc8.6.2
```

see:

- https://github.com/arm4rpi/pandoc-arm

ref:

- https://www.jianshu.com/p/ee7ba9a188d0

use ubuntu 19.10 instead of alpine 9.0:

- ubuntu 19.10 can install ghc 8.6.5 via apt
- alpine 9.0 armv7l can not build ghc

## local build

prepare `/tmp/ghc-arm-secret.txt` for docker push:

```
username=xxx
password=xxx
```

then run

```
make
```
