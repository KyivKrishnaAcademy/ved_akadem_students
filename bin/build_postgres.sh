#!/usr/bin/env sh

set -e

# docker buildx create --name multiarch --driver docker-container --use
docker buildx build --platform linux/amd64,linux/arm64 -t mpugach/postgres_ua:9.5 --push docker/postgres_ua
