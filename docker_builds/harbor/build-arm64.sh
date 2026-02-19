#!/usr/bin/env bash
set -euo pipefail

HARBOR_VERSION=${HARBOR_VERSION:-v2.9.0}
REGISTRY=${REGISTRY:-}
NAMESPACE=${NAMESPACE:-}
TAG=${TAG:-${HARBOR_VERSION}}
PLATFORMS=${PLATFORMS:-linux/arm64}
ENABLE_NOTARY=${ENABLE_NOTARY:-true}
ENABLE_TRIVY=${ENABLE_TRIVY:-true}
ENABLE_CHARTS=${ENABLE_CHARTS:-true}
PUSH=${PUSH:-false}
REGISTRY_USERNAME=${REGISTRY_USERNAME:-}
REGISTRY_PASSWORD=${REGISTRY_PASSWORD:-}

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
VENDOR_DIR="$ROOT_DIR/vendor"
mkdir -p "$VENDOR_DIR"

if [ ! -d "$VENDOR_DIR/harbor-arm" ]; then
  git clone --depth=1 https://github.com/goharbor/harbor-arm.git "$VENDOR_DIR/harbor-arm"
fi

cd "$VENDOR_DIR/harbor-arm"
printf "%s" "$HARBOR_VERSION" > VERSION

if ! docker buildx ls >/dev/null 2>&1; then
  echo "Docker Buildx is required" >&2
  exit 1
fi

make download
make compile_redis
make prepare_arm_data
make pre_update
make compile COMPILETAG=compile_golangimage
make build GOBUILDTAGS="include_oss include_gcs" BUILDBIN=true NOTARYFLAG="$ENABLE_NOTARY" TRIVYFLAG="$ENABLE_TRIVY" CHARTFLAG="$ENABLE_CHARTS" GEN_TLS=true PULL_BASE_FROM_DOCKERHUB=false

if [ "$PUSH" = "true" ] && [ -n "$REGISTRY" ] && [ -n "$NAMESPACE" ] && [ -n "$REGISTRY_USERNAME" ] && [ -n "$REGISTRY_PASSWORD" ]; then
  make pushimage -e DEVFLAG=false REGISTRYSERVER="${REGISTRY}/" REGISTRYUSER="$REGISTRY_USERNAME" REGISTRYPASSWORD="$REGISTRY_PASSWORD" REGISTRYPROJECTNAME="$NAMESPACE"
fi

