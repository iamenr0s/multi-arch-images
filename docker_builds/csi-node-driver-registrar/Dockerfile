FROM golang:1.15 AS builder
ARG VERSION=v1.3.0
ARG TARGETPLATFORM
WORKDIR /go/src/github.com/kubernetes-csi/node-driver-registrar/
RUN git clone --depth 1 -b "${VERSION}" https://github.com/kubernetes-csi/node-driver-registrar.git . \
     && GOARCH=$(echo $TARGETPLATFORM | cut -f2 -d '/') make build

FROM gcr.io/distroless/static@sha256:1061399c202961ab567994c1bd42327bccd6380a345dcf88bf9ad7d5c8e29571
WORKDIR /
COPY --from=builder /go/src/github.com/kubernetes-csi/node-driver-registrar/bin/csi-node-driver-registrar csi-node-driver-registrar
ENTRYPOINT ["/csi-node-driver-registrar"]