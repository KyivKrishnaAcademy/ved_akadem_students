#!/usr/bin/env sh

echo "Waiting for DB to get up"

while true; do
  nc -z postgres 5432 && echo "DB is up." && break
done

rm -rf public_nginx/*
cp -R public/* public_nginx

bundle exec rails db:migrate
bundle exec puma -C config/puma.rb
