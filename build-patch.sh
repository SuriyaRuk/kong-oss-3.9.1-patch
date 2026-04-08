#!/bin/bash
set -e

TAG=${1:-3.9.1-oidc-logout}

BUILDER_NAME="multiarch"

# Create builder if it doesn't exist, otherwise reuse it
if ! docker buildx inspect "${BUILDER_NAME}" >/dev/null 2>&1; then
  docker buildx create --name "${BUILDER_NAME}" --use
else
  docker buildx use "${BUILDER_NAME}"
fi

docker buildx build \
  --builder "${BUILDER_NAME}" \
  --platform linux/amd64,linux/arm64 \
  -f Dockerfile.DHI \
  -t ghcr.io/suriyaruk/kong-oss-3.9.1-patch:${TAG} \
  --push \
  .
