#!/usr/bin/env sh

bin/container_bundle_install.sh

bundle exec sidekiq -C config/sidekiq.yml
