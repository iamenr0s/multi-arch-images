FROM golang:alpine

ENV PACKER_DEV=1

RUN apk add --update git bash openssl qemu qemu-system-`uname -m` qemu-img
RUN go get github.com/mitchellh/gox
RUN go get github.com/hashicorp/packer

WORKDIR $GOPATH/src/github.com/hashicorp/packer

RUN /bin/bash scripts/build.sh

WORKDIR $GOPATH
ENTRYPOINT ["bin/packer"]
