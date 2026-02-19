# Harbor ARM64 Build

This repository automates building Harbor container images for `linux/arm64` and optionally pushes them to a container registry. It wraps the official Harbor ARM tooling and runs end-to-end on GitHub Actions or a local machine with Docker or Podman.

## Quick start

- Local prerequisites: Docker 20+ with Buildx, or Podman 4+, plus Git and Make.
- Default Harbor version: `v2.9.0`. Override via `HARBOR_VERSION`.

Local build (auto-detects Podman when available):

```bash
HARBOR_VERSION=v2.9.0 \
ENABLE_NOTARY=true \
ENABLE_TRIVY=true \
ENABLE_CHARTS=true \
./docker_builds/harbor/build-arm64.sh
```

Use Podman explicitly by setting the engine:

```bash
CONTAINER_ENGINE=podman \
./docker_builds/harbor/build-arm64.sh
```

Push images after build:

```bash
HARBOR_VERSION=v2.9.0 \
REGISTRY=ghcr.io \
NAMESPACE=your-org \
REGISTRY_USERNAME=your-user \
REGISTRY_PASSWORD=your-token \
PUSH=true \
./docker_builds/harbor/build-arm64.sh
```

## GitHub Actions

This repo includes a workflow that runs the same build in CI with QEMU and Buildx. Configure these repository secrets:

- `REGISTRY_USERNAME`
- `REGISTRY_PASSWORD`

Then trigger the workflow manually and provide inputs. Images are pushed when `push` is true and `registry` and `namespace` are set.

## Notes

- This automation relies on the upstream Harbor ARM process.
- Some third-party dependencies may lag on arm64. Adjust inputs as needed for your environment.

## References

- Harbor ARM build guidance: https://github.com/goharbor/harbor-arm
- Harbor build from source: https://goharbor.io/docs/2.0.0/build-customize-contribute/compile-guide/
