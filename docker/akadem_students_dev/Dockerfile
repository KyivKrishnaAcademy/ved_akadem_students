FROM ruby:2.3.1-alpine
MAINTAINER Maksym Pugach <pugach.m@gmail.com>

RUN mkdir /app
RUN bundle config git.allow_insecure true
RUN apk update && \
    apk upgrade && \
    apk add imagemagick git build-base postgresql postgresql-dev postgresql-client nodejs-lts python && \
    rm -rf /var/cache/apk/*
RUN npm install npm@3.6.0 -g

WORKDIR /app
