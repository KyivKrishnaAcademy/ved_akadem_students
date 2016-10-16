#!/usr/bin/env sh

echo "Checking gems cache"

file=/Gemfiles.md5

if [ -e "$file" ] && md5sum Gemfile* | diff "$file" -; then
  echo "Installed gems considered up to date"
else
  echo "Getting cache..."
  time rsync -art --delete /app/tmp/bundle /usr/local

  bundle install -j5 --retry 10 --without production

  echo "Saving cache..."
  time rsync -art --delete /usr/local/bundle /app/tmp

  md5sum Gemfile* > "$file"
fi
