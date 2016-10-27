#!/usr/bin/env sh

timestamp=$(date "+%Y%m%d%H%M")

docker build \
       --no-cache \
       -t mpugach/akadem_students \
       -t "mpugach/akadem_students:$timestamp" \
       docker/akadem_students_prod
