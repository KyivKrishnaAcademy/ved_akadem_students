#!/usr/bin/env sh

set -e

. ./bin/lib/build_by_tag_and_dir.sh

build_by_tag_and_dir 'mpugach' 'akadem_students_prod' $(date "+%Y%m%d%H%M") '--no-cache'
