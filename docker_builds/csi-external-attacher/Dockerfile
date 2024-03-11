FROM golang:1.15 AS builder
ARG VERSION=v1.2.0
ARG TARGETPLATFORM
WORKDIR /go/src/github.com/kubernetes-csi/external-attacher/
RUN git clone --depth 1 -b "${VERSION}" https://github.com/kubernetes-csi/external-attacher.git . \
     && GOARCH=$(echo $TARGETPLATFORM | cut -f2 -d '/') make build

FROM gcr.io/distroless/static@sha256:3f76144aca7404aa2de8021ea9e8e8e6551523f3dacb872a5d3c27f8bb2bf7dc
COPY --from=builder /go/src/github.com/kubernetes-csi/external-attacher/bin/csi-attacher csi-attacher
ENTRYPOINT ["/csi-attacher"]