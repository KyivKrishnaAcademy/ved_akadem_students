FROM ruby:2.3.1-alpine
MAINTAINER Maksym Pugach <pugach.m@gmail.com>

RUN apk update && \
    apk upgrade && \
    apk add imagemagick git build-base postgresql postgresql-dev postgresql-client nodejs-lts rsync && \
    rm -rf /var/cache/apk/*
RUN mkdir /app
RUN bundle config git.allow_insecure true

WORKDIR /app

ENTRYPOINT top -bc
