#!/usr/bin/env sh

set -e

. ./bin/lib/build_by_tag_and_dir.sh

build_by_tag_and_dir 'mpugach' 'environmental_nginx' $(date "+%Y%m%d%H%M")
