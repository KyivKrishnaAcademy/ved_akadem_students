#!/usr/bin/env bash

echo "installing PhantomJS"

export PHANTOMJS_VERSION=2.1.1
export PHANTOMJS_DIR=$PROJECT_HOME/phantomjs
export PATH=$PHANTOMJS_DIR/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/bin:$PATH
export OPENSSL_CONF=asdasdas

if (! [ -x "$(command -v phantomjs)" ]) || [ $(phantomjs --version) != $PHANTOMJS_VERSION ]; then
  rm -rf $PHANTOMJS_DIR
  mkdir -p $PHANTOMJS_DIR

  phantom_js_archive_name="phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2"

  wget https://github.com/Medium/phantomjs/releases/download/v$PHANTOMJS_VERSION/$phantom_js_archive_name -O $PHANTOMJS_DIR/$phantom_js_archive_name
  tar -xvf $PHANTOMJS_DIR/$phantom_js_archive_name -C $PHANTOMJS_DIR
fi

phantomjs --version
