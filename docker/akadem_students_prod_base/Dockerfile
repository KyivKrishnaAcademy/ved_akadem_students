FROM ruby:2.3.1-alpine
MAINTAINER Maksym Pugach <pugach.m@gmail.com>

RUN mkdir /app
RUN echo "gem: --no-rdoc --no-ri --no-document --suggestions" >> ~/.gemrc
RUN bundle config git.allow_insecure true

RUN apk update && \
    apk upgrade && \
    apk add postgresql-dev imagemagick

WORKDIR /app
