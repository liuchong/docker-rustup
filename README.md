# rustup

Automated builded images on [store](https://store.docker.com/community/images/liuchong/rustup/) and [hub](https://hub.docker.com/r/liuchong/rustup/) for rust-lang with musl added, using rustup "the ultimate way to install RUST".

***note:***

1. *Please check [liuchong/rustup tags](https://store.docker.com/community/images/liuchong/rustup/tags) on [store](https://store.docker.com/) instead of [Build Details](https://hub.docker.com/r/liuchong/rustup/builds/) on [hub](https://hub.docker.com/)*
2. *The "build branch" and "tags" are meaningless but just docker images(which are with stable/versions tags) for building*
3. *the "version tags" are available from 1.15.0*
4. *the stable/beta/nightly tags does not have the package "musl-tools" and the target "x86_64-unknown-linux-musl" installed by default*

# Usage

#### pull the images:

``` shell
> docker pull liuchong/rustup
> docker pull liuchong/rustup:musl
```

the tags are:

- stable/version: [(stable/Dockerfile)](https://github.com/liuchong/docker-rustup/blob/master/dockerfiles/stable/Dockerfile)
- stable-musl/version-musl: [(stable/Dockerfile_musl)](https://github.com/liuchong/docker-rustup/blob/master/dockerfiles/stable/Dockerfile_musl)
- beta: [(beta/Dockerfile)](https://github.com/liuchong/docker-rustup/blob/master/dockerfiles/beta/Dockerfile)
- beta-musl: [(beta/Dockerfile_musl)](https://github.com/liuchong/docker-rustup/blob/master/dockerfiles/beta/Dockerfile_musl)
- nightly: [(nightly/Dockerfile)](https://github.com/liuchong/docker-rustup/blob/master/dockerfiles/nightly/Dockerfile)
- nightly-musl: [(nightly/Dockerfile_musl)](https://github.com/liuchong/docker-rustup/blob/master/dockerfiles/nightly/Dockerfile_musl)
- all3: [(all3/Dockerfile)](https://github.com/liuchong/docker-rustup/blob/master/dockerfiles/all3/Dockerfile)
- all3-musl, musl, latest: [(all3/Dockerfile_musl)](https://github.com/liuchong/docker-rustup/blob/master/dockerfiles/all3/Dockerfile_musl)
- plus: [(all3/Dockerfile_plus)](https://github.com/liuchong/docker-rustup/blob/master/dockerfiles/all3/Dockerfile_plus)

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
