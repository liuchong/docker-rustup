FROM debian:latest
MAINTAINER Liu Chong <mail@clojure.cn>
WORKDIR /root
RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential openssl ca-certificates libssl-dev curl file && \
    apt-get clean && \
    curl https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-setup -O && \
    chmod +x rustup-setup && \
    ./rustup-setup --default-toolchain stable -y && \
    rm -f rustup-setup
ENV PATH="/root/.cargo/bin:$PATH"
RUN apt-get install --no-install-recommends -y nano vim emacs && \
    apt-get clean
RUN rustup default stable && \
    rustup default beta && \
    rustup default nightly
