FROM alpine:latest

MAINTAINER enr0s

ENV PACKER_VERSION=1.6.0

RUN apk add --update git bash curl openssl libvirt-daemon qemu qemu-system-`uname -m | sed 's|armv7l|arm|'` qemu-img

RUN curl -o ./packer.zip  https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_`uname -m | sed 's|armv7l|arm|' | sed 's|x86_64|amd64|' | sed 's|aarch64|arm64|'`.zip && \
  unzip packer.zip -d /usr/local/bin && \
  rm -f packer.zip

RUN mknod /dev/kvm c 10 232 

ENTRYPOINT ["/usr/local/bin/packer"]
