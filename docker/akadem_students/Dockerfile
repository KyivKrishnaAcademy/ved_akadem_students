FROM ruby:2.4.9-slim-buster AS base

LABEL maintainer="Maksym Pugach <pugach.m@gmail.com>"

ENV APP_USER=app
ENV BUNDLER_VERSION=1.17.3
ENV APP_HOME=/home/${APP_USER}
ENV PROJECT_HOME=${APP_HOME}/students_crm

RUN echo "install: --no-rdoc --no-ri --no-document --suggestions" >> ~/.gemrc
RUN echo "update: --no-rdoc --no-ri --no-document --suggestions" >> ~/.gemrc
RUN gem update --system 3.2.3
RUN apt-get update && apt-get install -y libyaml-dev
RUN gem uninstall bundler -a -x || true \
 && gem install bundler -v 1.17.3
RUN bundle _1.17.3_ config git.allow_insecure true
RUN mkdir -p $PROJECT_HOME

RUN apt-get update \
 && apt-get install -y \
    curl \
    gnupg \
    imagemagick \
    lsb-release \
    netcat \
    locales \
 && echo "deb https://apt-archive.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" \
    > /etc/apt/sources.list.d/pgdg.list \
 && curl -L https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
 && apt-get update \
 && apt-get install -y \
    libpq-dev \
    postgresql-client-9.5 \
 && apt-get remove --purge -y \
    curl \
    gnupg \
    lsb-release \
 && apt autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN localedef -i uk_UA -c -f UTF-8 -A /usr/share/locale/locale.alias uk_UA.UTF-8

ENV LANG=uk_UA.utf8

WORKDIR $PROJECT_HOME
# ______________________________________________________________________________________________________________________

FROM base AS base_with_node

ARG NODE_LTS_VERSION=10
ARG NPM_VERSION=6.13.0

ENV NG_CLI_ANALYTICS=false

RUN apt-get update \
 && apt-get install -y \
    curl \
 && curl -sL https://deb.nodesource.com/setup_${NODE_LTS_VERSION}.x | bash - \
 && apt-get install -y \
    nodejs \
 && npm install -g npm@${NPM_VERSION} \
 && apt-get remove --purge -y \
    curl \
 && apt autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# ______________________________________________________________________________________________________________________

FROM base_with_node AS development

ENV PHANTOMJS_VERSION=2.1.1
ENV PHANTOMJS_DIR=$PROJECT_HOME/phantomjs
ENV PATH=$PHANTOMJS_DIR/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/bin:$PATH

RUN apt-get update \
 && apt-get install -y \
    build-essential \
    git \
    wget \
    libmagickwand-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# ______________________________________________________________________________________________________________________

FROM base_with_node AS production_builder

ARG GIT_BRANCH=master
ARG GIT_REPO=https://github.com/KyivKrishnaAcademy/ved_akadem_students.git

ENV RAILS_ENV=assets_builder

RUN apt-get update
RUN apt-get install -y \
    build-essential \
    git \
    libmagickwand-dev
RUN git clone -b ${GIT_BRANCH} ${GIT_REPO} .
RUN bundle _1.17.3_ install -j5 --retry 10 --frozen --no-cache --without development test
RUN npm install
RUN cd client && npm install && cd ..

COPY .env .env

RUN export $(cat .env | grep -v "# NOTE:" | xargs) && bundle _1.17.3_ exec rake assets:precompile

RUN rm -rf .git app/assets/javascript* app/assets/stylesheets node_modules client .env

# ______________________________________________________________________________________________________________________

FROM base_with_node

ENV RAILS_ENV=production

COPY --from=production_builder $PROJECT_HOME $PROJECT_HOME

RUN apt-get update \
 && apt-get install -y \
    build-essential \
    git \
 && bundle _1.17.3_ install -j5 --retry 10 --frozen --no-cache --without assets_builder development test \
 && apt-get remove --purge -y \
    build-essential \
    git \
 && apt autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
