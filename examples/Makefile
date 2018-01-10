TOP_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
EXTERN_C_DIR := $(TOP_DIR)target/extern_C
TMP_DIR := $(shell mktemp -d)

SSL_VERSION := 1.0.2n

all: compile build push

all-docker: compile-docker build push

clean:
	@echo "Clean build environment."
	rm -rf ./target

openssl:
	@echo "Building openssl."
	cp -a deps/openssl-$(SSL_VERSION) $(TMP_DIR)/ && \
	cd $(TMP_DIR)/openssl-$(SSL_VERSION) && \
	./config --prefix=$(EXTERN_C_DIR) && \
	make depend && \
	make install

build:
	@echo "Build the static binary of wrapper."
	EXTERN_C_DIR=$(EXTERN_C_DIR) \
	PATH=$(EXTERN_C_DIR)/bin:$$PATH \
	OPENSSL_LIB_DIR=$(EXTERN_C_DIR)/lib \
	OPENSSL_INCLUDE_DIR=$(EXTERN_C_DIR)/include \
	OPENSSL_STATIC=1 \
	cargo build --target=x86_64-unknown-linux-musl --release --verbose

build-docker:
	@echo "Build the static binary of wrapper use docker image."
	docker run --rm \
	-v /tmp/.cargo.docker/git:/root/.cargo/git \
	-v /tmp/.cargo.docker/registry:/root/.cargo/registry \
	-v $$PWD:$$PWD -w $$PWD -t liuchong/rustup:musl sh -c \
	"EXTERN_C_DIR=$(EXTERN_C_DIR) cargo build --release --verbose; \
	chown -R $$(id -u):$$(id -g) target"

compile: openssl build

compile-docker: build-docker

image:
	@echo "Building docker image..."
	docker build -t my-hub.org/path/my-image:$(tag) .

push: image
	@echo "Uploading..."
	docker push my-hub.org/path/my-image:$(tag)
