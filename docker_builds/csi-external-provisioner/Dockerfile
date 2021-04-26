FROM golang:1.16 AS builder
ARG VERSION=v1.3.0
ARG TARGETPLATFORM
WORKDIR /go/src/github.com/kubernetes-csi/external-provisioner/
RUN git clone --depth 1 -b "${VERSION}" https://github.com/kubernetes-csi/external-provisioner.git . \
     && GOARCH=$(echo $TARGETPLATFORM | cut -f2 -d '/') make build

FROM gcr.io/distroless/static@sha256:23aa732bba4c8618c0d97c26a72a32997363d591807b0d4c31b0bbc8a774bddf
WORKDIR /
COPY --from=builder /go/src/github.com/kubernetes-csi/external-provisioner/bin/csi-provisioner csi-provisioner
ENTRYPOINT ["/csi-node-driver-registrar"]