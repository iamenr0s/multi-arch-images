FROM golang:1.15 AS builder
ARG VERSION=v1.2.0
ARG TARGETPLATFORM
WORKDIR /go/src/github.com/kubernetes-csi/external-attacher/
RUN git clone --depth 1 -b "${VERSION}" https://github.com/kubernetes-csi/external-attacher.git . \
     && GOARCH=$(echo $TARGETPLATFORM | cut -f2 -d '/') make build

FROM gcr.io/distroless/static@sha256:d49f214e6f1bae819e24f651156552b073725592cae128a66eade0c6280f02e1
COPY --from=builder /go/src/github.com/kubernetes-csi/external-attacher/bin/csi-attacher csi-attacher
ENTRYPOINT ["/csi-attacher"]