FROM golang:1.26 AS builder
ARG VERSION=v1.3.0
ARG TARGETPLATFORM
WORKDIR /go/src/github.com/kubernetes-csi/external-provisioner/
RUN git clone --depth 1 -b "${VERSION}" https://github.com/kubernetes-csi/external-provisioner.git . \
     && GOARCH=$(echo $TARGETPLATFORM | cut -f2 -d '/') make build

FROM gcr.io/distroless/static@sha256:262ae336f8e9291f8edc9a71a61d5d568466edc1ea4818752d4af3d230a7f9ef
WORKDIR /
COPY --from=builder /go/src/github.com/kubernetes-csi/external-provisioner/bin/csi-provisioner csi-provisioner
ENTRYPOINT ["/csi-node-driver-registrar"]