#!/usr/bin/env sh

set -e

main_tag="mpugach/akadem_students_dev"

timestamp=$(date "+%Y%m%d%H%M")

docker build -t "$main_tag" -t "$main_tag:$timestamp" docker/akadem_students_dev

docker push "$main_tag:$timestamp"
docker push "$main_tag:latest"
