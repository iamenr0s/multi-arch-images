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

# Container engine selection: docker or podman (auto-detect if not set)
CONTAINER_ENGINE=${CONTAINER_ENGINE:-}
if [ -z "${CONTAINER_ENGINE}" ]; then
  if command -v podman >/dev/null 2>&1; then
    CONTAINER_ENGINE=podman
  else
    CONTAINER_ENGINE=docker
  fi
fi

if ! command -v "$CONTAINER_ENGINE" >/dev/null 2>&1; then
  echo "Container engine '$CONTAINER_ENGINE' not found in PATH" >&2
  exit 1
fi

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
VENDOR_DIR="$ROOT_DIR/vendor"
mkdir -p "$VENDOR_DIR"

if [ ! -d "$VENDOR_DIR/harbor-arm" ]; then
  git clone --depth=1 https://github.com/goharbor/harbor-arm.git "$VENDOR_DIR/harbor-arm"
fi

cd "$VENDOR_DIR/harbor-arm"
printf "%s" "$HARBOR_VERSION" > VERSION

# If using Podman, create a docker CLI shim to satisfy Harbor's docker version checks
if [ "$CONTAINER_ENGINE" = "podman" ]; then
  SHIM_DIR="$VENDOR_DIR/.docker-shim"
  mkdir -p "$SHIM_DIR"
  SHIM_BIN="$SHIM_DIR/docker"
  cat >"$SHIM_BIN" <<'EOS'
#!/usr/bin/env bash
set -e
# Emulate docker version output expected by Harbor's env check
if [ "${1:-}" = "version" ]; then
  if [ "${2:-}" = "--format" ]; then
    echo "20.10.10"
    exit 0
  fi
  echo "Docker version 20.10.10, build f000000"
  exit 0
fi
if [ "${1:-}" = "--version" ]; then
  echo "Docker version 20.10.10, build f000000"
  exit 0
fi
exec podman "$@"
EOS
  chmod +x "$SHIM_BIN"
  COMPOSE_SHIM_BIN="$SHIM_DIR/docker-compose"
  cat >"$COMPOSE_SHIM_BIN" <<'EOSC'
#!/usr/bin/env bash
set -e
if [ "${1:-}" = "version" ]; then
  echo "docker-compose version 1.29.2, build f000000"
  exit 0
fi
if command -v podman >/dev/null 2>&1 && podman compose version >/dev/null 2>&1; then
  exec podman compose "$@"
fi
if command -v podman-compose >/dev/null 2>&1; then
  exec podman-compose "$@"
fi
echo "docker-compose not available; install podman compose or podman-compose" >&2
exit 1
EOSC
  chmod +x "$COMPOSE_SHIM_BIN"
  export PATH="$SHIM_DIR:$PATH"
fi

# Buildx is only required when using Docker; Podman provides native build capabilities
if [ "$CONTAINER_ENGINE" = "docker" ]; then
  if ! docker buildx ls >/dev/null 2>&1; then
    echo "Docker Buildx is required" >&2
    exit 1
  fi
fi

# Ensure upstream Makefiles use the selected container engine
export DOCKER="$CONTAINER_ENGINE"
export CONTAINER_ENGINE

make download
make compile_redis
make prepare_arm_data
make pre_update
make compile COMPILETAG=compile_golangimage
make build GOBUILDTAGS="include_oss include_gcs" BUILDBIN=true NOTARYFLAG="$ENABLE_NOTARY" TRIVYFLAG="$ENABLE_TRIVY" CHARTFLAG="$ENABLE_CHARTS" GEN_TLS=true PULL_BASE_FROM_DOCKERHUB=false

if [ "$PUSH" = "true" ] && [ -n "$REGISTRY" ] && [ -n "$NAMESPACE" ] && [ -n "$REGISTRY_USERNAME" ] && [ -n "$REGISTRY_PASSWORD" ]; then
  make pushimage -e DEVFLAG=false REGISTRYSERVER="${REGISTRY}/" REGISTRYUSER="$REGISTRY_USERNAME" REGISTRYPASSWORD="$REGISTRY_PASSWORD" REGISTRYPROJECTNAME="$NAMESPACE"
fi
