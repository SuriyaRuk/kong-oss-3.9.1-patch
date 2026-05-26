#!/bin/bash
set -e

TAG=${1:-1.29.2.5}

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
  -f Dockerfile.DHI-without-oidc \
  -t suriyaruk/kong-oss-3.9.1-patch:${TAG} \
  --push \
  .
