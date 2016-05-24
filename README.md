# rustup

Automated builded images for rust-lang with rustup, "the ultimate way to install RUST"

# Usage

###### note: the stable/beta/nightly branches does not have the package "musl-tools" and the target "x86_64-unknown-linux-musl" installed by default.

1. pull the images:

``` shell
> docker pull liuchong/rustup
```

2. setup the Dockerfile:

``` dockerfile
FROM liuchong/rustup
...
```

3. musl static building:

``` bash
# you can also use "latest", which is the same as "musl".
docker run -v $PWD:/build_dir -w /build_dir -t liuchong/rustup:musl cargo build --release
# or, you may want also to fix the ownership and remove container after run as below:
docker run --rm -v $PWD:/build_dir -w /build_dir -t liuchong/rustup:musl sh -c "cargo build --release && chown -R $(id -u):$(id -g) target"
```

then, you can write a dockerfile like this and build you app image(so, the image will be very small):

``` dockerfile
FROM scratch
ADD target/x86_64-unknown-linux-musl/release/your-app /
CMD ["/your-app"]
# or something like this:
# CMD ["/your-app", "--production"]
```
