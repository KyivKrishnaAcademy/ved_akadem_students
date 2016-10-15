#!/usr/bin/env sh

md5sum Gemfile* | diff /Gemfiles.md5 -

if $?; then
  echo "Installed gems considered up to date"
else
  echo "Getting cache..."
  time rsync -art --delete /app/tmp/bundle /usr/local

  bundle install -j5 --retry 10 --without production

  echo "Saving cache..."
  time rsync -art --delete /usr/local/bundle /app/tmp

  md5sum Gemfile* > /Gemfiles.md5
fi
