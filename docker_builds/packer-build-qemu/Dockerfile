FROM alpine:latest
MAINTAINER enr0s

ENV PACKER_VERSION=1.6.0
ENV ARCH=`uname -m | sed 's|armv7l|arm|' | sed 's|x86_64|amd64|' | sed 's|aarch64|arm64|'`

RUN apk add --update git bash wget openssl qemu qemu-system-`uname -m | sed 's|armv7l|arm|'` qemu-img

ADD https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_${OS_ARCH}.zip ./

RUN unzip packer_${PACKER_VERSION}_linux_${OS_ARCH}.zip -d /usr/local/bin

ENTRYPOINT [ "/usr/local/bin/packer" ]
