#!/usr/bin/env bash
export PATH="/usr/local/bundle/bin:$PATH"
env | sort

cd client
echo "Skipping npm install in client/ (handled during image build)"
cd ..

echo "Waiting for DB to get up"

while true; do
  nc -z postgres 5432 && echo "DB is up." && break
  sleep 2
done

bin/rails db:create

if bin/rails db:version; then
  bin/rails db:migrate
  bin/rails db:seed
  bin/rails db:schema:dump
else
  bin/rails db:structure:load
  bin/rails db:seed
fi

pidfile=${PROJECT_HOME}/tmp/pids/server.pid

[ -e "$pidfile" ] && rm "$pidfile"

foreman start
