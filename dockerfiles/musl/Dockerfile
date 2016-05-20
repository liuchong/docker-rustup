FROM debian:latest
MAINTAINER Liu Chong <mail@clojure.cn>
WORKDIR /root
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    build-essential ca-certificates curl file xutils-dev \
    musl-tools nano vim emacs && \
    apt-get clean
RUN curl https://sh.rustup.rs -sSf | \
    sh -s -- --default-toolchain stable -y && \
    /root/.cargo/bin/rustup update beta && \
    /root/.cargo/bin/rustup update nightly && \
    /root/.cargo/bin/rustup target add x86_64-unknown-linux-musl && \
    mkdir /.cargo && \
    echo "[build]\ntarget = \"x86_64-unknown-linux-musl\"" > /.cargo/config
RUN curl https://www.openssl.org/source/openssl-1.0.2h.tar.gz -O && \
    tar -xzf openssl-1.0.2h.tar.gz && \
    cd openssl-1.0.2h && ./config && make depend && make install && \
    cd .. && rm -rf openssl-1.0.2h*
ENV PATH="/root/.cargo/bin:$PATH" \
    OPENSSL_LIB_DIR=/usr/local/ssl/lib \
    OPENSSL_INCLUDE_DIR=/usr/local/ssl/include \
    OPENSSL_STATIC=1
