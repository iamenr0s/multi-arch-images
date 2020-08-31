FROM golang:1.13 AS builder

ARG VERSION=2.2.0
ARG TARGETPLATFORM

WORKDIR /go/src/github.com/kubernetes-csi/external-attacher/

RUN git clone --depth 1 -b "v${VERSION}" https://github.com/kubernetes-csi/external-attacher.git . \
     && GOARCH=$TARGETPLATFORM | cut -f2 -d '/') make build

FROM gcr.io/distroless/static@sha256:08cce4d65b19780e10b555578a0f9c9af51310308ec31e648577122d40e6922a


LABEL description="CSI External Attacher"

COPY --from=builder /go/src/github.com/kubernetes-csi/external-attacher/bin/csi-attacher csi-attacher

ENTRYPOINT ["/csi-attacher"]
