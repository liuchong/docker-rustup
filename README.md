# rustup

[![Build Status](https://github.com/liuchong/docker-rustup/actions/workflows/build.yml/badge.svg)](https://github.com/liuchong/docker-rustup/actions/workflows/build.yml)
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fliuchong%2Fdocker-rustup.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Fliuchong%2Fdocker-rustup?ref=badge_shield)

Automated builded images on [store](https://store.docker.com/community/images/liuchong/rustup/) and [hub](https://hub.docker.com/r/liuchong/rustup/) for rust-lang with musl added, using rustup "the ultimate way to install RUST".

***tag changed: all3 -> all***

***note:***

0. *Image buildings are ***triggered*** by automated builds on cloud.docker.com when "build branch" is updated by build.sh*
1. *Please check [liuchong/rustup tags](https://store.docker.com/community/images/liuchong/rustup/tags) on [store](https://store.docker.com/) instead of [Build Details](https://hub.docker.com/r/liuchong/rustup/builds/) on [hub](https://hub.docker.com/)*
2. *The "build branch" and "tags" are meaningless but just docker images(which are with stable/versions tags) for building*
3. *the "version tags" are available from 1.15.0*
4. *the stable/beta/nightly tags does not have the package "musl-tools" and the target "x86_64-unknown-linux-musl" installed by default*

# Usage

## Images

#### pull the images:

``` shell
> docker pull liuchong/rustup
> docker pull liuchong/rustup:musl
```

the tags are:

- stable/version: [(stable/Dockerfile)](https://github.com/liuchong/docker-rustup/blob/master/dockerfiles/stable/Dockerfile)
- stable-musl/version-musl: [(stable_musl/Dockerfile)](https://github.com/liuchong/docker-rustup/blob/master/dockerfiles/stable_musl/Dockerfile)
- beta: [(beta/Dockerfile)](https://github.com/liuchong/docker-rustup/blob/master/dockerfiles/beta/Dockerfile)
- beta-musl: [(beta_musl/Dockerfile)](https://github.com/liuchong/docker-rustup/blob/master/dockerfiles/beta_musl/Dockerfile)
- nightly: [(nightly/Dockerfile)](https://github.com/liuchong/docker-rustup/blob/master/dockerfiles/nightly/Dockerfile)
- nightly-musl: [(nightly_musl/Dockerfile)](https://github.com/liuchong/docker-rustup/blob/master/dockerfiles/nightly_musl/Dockerfile)
- nightly-onbuild: [(nightly_onbuild/Dockerfile)](https://github.com/liuchong/docker-rustup/blob/master/dockerfiles/nightly_onbuild/Dockerfile)
- nightly-musl-onbuild: [(nightly_musl_onbuild/Dockerfile)](https://github.com/liuchong/docker-rustup/blob/master/dockerfiles/nightly_musl_onbuild/Dockerfile)
- all: [(all/Dockerfile)](https://github.com/liuchong/docker-rustup/blob/master/dockerfiles/all/Dockerfile)
- all-musl, musl, latest: [(all_musl/Dockerfile)](https://github.com/liuchong/docker-rustup/blob/master/dockerfiles/all_musl/Dockerfile)
- plus: [(plus/Dockerfile)](https://github.com/liuchong/docker-rustup/blob/master/dockerfiles/plus/Dockerfile)

#### use the image

###### just setup the Dockerfile:

``` dockerfile
FROM liuchong/rustup:stable
...
```

###### or you maybe prefer to make a musl static building:

``` bash
# you can also use "latest", which is the same as "musl".
docker run -v $PWD:/build_dir -w /build_dir -t liuchong/rustup:musl cargo build --release
# or, you may want to use nightly channel and fix the ownership and remove container after run as below:
docker run --rm -v $PWD:/build_dir -w /build_dir -t liuchong/rustup:musl sh -c "rustup run nightly cargo build --release && chown -R $(id -u):$(id -g) target"
```

then, you can write a dockerfile like this and build you app image(so, the image will be very small):

``` dockerfile
FROM scratch
ADD target/x86_64-unknown-linux-musl/release/your-app /
CMD ["/your-app"]
# or something like this:
# CMD ["/your-app", "--production"]
```

## Build script

``` bash
# Use automatical checked version from website for current stable builds:
./build.sh
# Use a specified stable version from command line:
./build.sh 1.21.0
# Do not build versioning tag, just pass a string which is not fit the version pattern,
# as the first argument:
./build.sh no-version
./build.sh foo
```

## License

[MIT](LICENSE)

[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fliuchong%2Fdocker-rustup.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fliuchong%2Fdocker-rustup?ref=badge_large)

# Build

2025-09-26 01:43:51+00:00
