#!/usr/bin/env sh

set -e

. ./bin/lib/build_by_tag_and_dir.sh

build_by_tag_and_dir 'mpugach' 'akadem_students_prod' 'docker/akadem_students/Dockerfile' '.' '--no-cache'
