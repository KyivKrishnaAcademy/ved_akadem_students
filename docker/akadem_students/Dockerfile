FROM ruby:3.4.2 AS base

LABEL maintainer="Maksym Pugach <pugach.m@gmail.com>"

ENV APP_USER=app
ENV APP_HOME=/home/${APP_USER}
ENV PROJECT_HOME=${APP_HOME}/students_crm

RUN echo "install: --no-rdoc --no-ri --no-document --suggestions" >> ~/.gemrc
RUN echo "update: --no-rdoc --no-ri --no-document --suggestions" >> ~/.gemrc
RUN printf '#!/bin/bash\nif [[ "$1" == "--version" ]]; then\n  exec /usr/local/bin/phantomjs --version\nelse\n  exec xvfb-run --auto-servernum --server-args="-screen 0 1024x768x24" /usr/local/bin/phantomjs "$@"\nfi\n' > /usr/local/bin/xvfb-phantomjs \
 && chmod +x /usr/local/bin/xvfb-phantomjs
RUN gem update --system
RUN gem install bundler:2.6.5
RUN bundle config git.allow_insecure true
RUN mkdir -p $PROJECT_HOME

RUN apt-get update \
 && apt-get install -y \
    curl \
    gnupg \
    imagemagick \
    lsb-release \
    netcat-openbsd \
    locales \
    xvfb \
 && apt-get update \
 && apt-get install -y \
    libpq-dev \
    postgresql-client \
 && apt-get remove --purge -y \
    curl \
    gnupg \
    lsb-release \
 && apt autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN localedef -i uk_UA -c -f UTF-8 -A /usr/share/locale/locale.alias uk_UA.UTF-8

ENV LANG=uk_UA.utf8
ENV PATH="/usr/local/bundle/bin:${PATH}"

WORKDIR $PROJECT_HOME
# ______________________________________________________________________________________________________________________

FROM base AS base_with_node

ARG NODE_LTS_VERSION=10
ARG NPM_VERSION=6.14.12

ENV NG_CLI_ANALYTICS=false

RUN apt-get update \
    && apt-get install -y curl wget build-essential \
    && apt-get install -y software-properties-common \
    && echo "deb http://deb.debian.org/debian buster main" > /etc/apt/sources.list.d/buster.list \
    && apt-get update \
    && apt-get install -y python2 \
    && ln -sf /usr/bin/python2 /usr/bin/python \
    && curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash \
    && export NVM_DIR="/root/.nvm" \
    && [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" \
    && nvm install 10 \
    && nvm use 10 \
    && npm install -g npm@6.14.12 \
    && apt-get remove --purge -y curl wget \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV NVM_DIR="/root/.nvm"
ENV PATH="$NVM_DIR/versions/node/v10.24.1/bin:$PATH"
# ______________________________________________________________________________________________________________________

FROM base_with_node AS development

RUN apt-get update \
 && apt-get install -y \
    build-essential \
    git \
    wget \
    libmagickwand-dev \
    wget \
    gnupg \
    unzip \
    curl \
    ca-certificates \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libgdk-pixbuf2.0-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils \
    xvfb \
    x11-utils \
    && wget https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2 -O /tmp/phantomjs.tar.bz2 \
    && tar -xjf /tmp/phantomjs.tar.bz2 -C /opt \
    && ln -sf /opt/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs \
    && rm /tmp/phantomjs.tar.bz2 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY Gemfile Gemfile.lock $PROJECT_HOME/
WORKDIR $PROJECT_HOME
COPY . $PROJECT_HOME
RUN bundle install -j5 --retry 10 --without production
RUN npm install
RUN cd client && npm install && cd ..
RUN bundle binstubs rails foreman

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
RUN bundle install -j5 --retry 10 --frozen --no-cache --without development test
RUN npm install
RUN cd client && npm install && cd ..

COPY .env .env

RUN export $(cat .env | grep -v "# NOTE:" | xargs) && bundle exec rake assets:precompile

RUN rm -rf .git app/assets/javascript* app/assets/stylesheets node_modules client .env

# ______________________________________________________________________________________________________________________

FROM base_with_node

ENV RAILS_ENV=production

COPY --from=production_builder $PROJECT_HOME $PROJECT_HOME

RUN apt-get update \
 && apt-get install -y \
    build-essential \
    git \
 && bundle install -j5 --retry 10 --frozen --no-cache --without assets_builder development test \
 && apt-get remove --purge -y \
    build-essential \
    git \
 && apt autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
