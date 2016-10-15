#!/usr/bin/env sh

env

bin/container_bundle_install.sh

bundle exec rails db:create
bundle exec rails db:migrate:status

if $?; then
  bundle exec rails db:migrate
  bundle exec rails db:schema:dump
else
  bundle exec rails db:structure:load
  bundle exec rails db:seed
fi

rm /usr/src/app/tmp/pids/server.pid

bundle exec rails s -b 0.0.0.0
