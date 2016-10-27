FROM ruby:2.3.1-alpine
MAINTAINER Maksym Pugach <pugach.m@gmail.com>

RUN mkdir /app

WORKDIR /app

RUN apk update && \
    apk upgrade && \
    apk add git postgresql postgresql-dev postgresql-client \
            nodejs-lts python sqlite-dev build-base imagemagick && \

    git clone -b 174_move_dev_to_docker https://github.com/KyivKrishnaAcademy/ved_akadem_students.git . && \

    echo "gem: --no-rdoc --no-ri --no-document --suggestions" >> ~/.gemrc && \
    bundle config git.allow_insecure true && \
    bundle install -j5 --retry 10 --without development test && \

    npm install npm@3.6.0 -g && \
    npm install && \

    mv config/database.yml config/database.tmp.yml && cp config/database.build.yml config/database.yml && \
    bundle exec rake assets:precompile RAILS_ENV=production && \
    mv config/database.tmp.yml config/database.yml && \

    apk del python sqlite-dev git build-base nodejs-lts && \

    rm -rf node_modules client app/assets config/*.sqlite3 /var/cache/apk/*

ENTRYPOINT top -bc
