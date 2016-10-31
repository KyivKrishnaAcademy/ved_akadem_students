#!/usr/bin/env sh

env

bundle install -j5 --retry 10 --without production
bundle clean --force

npm install
npm prune

echo "Waiting for DB to get up"

while true; do
  nc -z postgres 5432 && echo "DB is up." && break
done

bundle exec rails db:create

if bundle exec rails db:migrate:status; then
  bundle exec rails db:migrate
  bundle exec rails db:schema:dump
else
  bundle exec rails db:structure:load
  bundle exec rails db:seed
fi

pidfile=/app/tmp/pids/server.pid

[ -e "$pidfile" ] && rm "$pidfile"

foreman start -f Procfile.dev -t 10
