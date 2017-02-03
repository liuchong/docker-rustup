FROM liuchong/rustup:all3-musl

MAINTAINER Liu Chong <mail@clojure.cn>

WORKDIR /root

# plus
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    nano vim emacs && \
    rm -rf /var/lib/apt/lists/*
