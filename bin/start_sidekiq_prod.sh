#!/usr/bin/env sh

echo "Waiting for DB to get up"

while true; do
  nc -z postgres 5432 && echo "DB is up." && break
done

mkdir -p public_nginx/sidekiq
cp -R /usr/local/bundle/gems/sidekiq-*/web/assets/{javascripts,stylesheets,images} public_nginx/sidekiq

bundle exec sidekiq -C config/sidekiq.yml
