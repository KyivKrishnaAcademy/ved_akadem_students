# Базовый образ с Ruby
FROM ruby:2.4.9-slim-buster AS base

LABEL maintainer="Maksym Pugach <pugach.m@gmail.com>"

ENV APP_USER=app
ENV APP_HOME=/home/${APP_USER}
ENV PROJECT_HOME=${APP_HOME}/students_crm

# Настройка gem
RUN echo "install: --no-rdoc --no-ri --no-document --suggestions" >> ~/.gemrc
RUN echo "update: --no-rdoc --no-ri --no-document --suggestions" >> ~/.gemrc
RUN gem update --system 3.3.26
RUN gem install bundler:1.17.3
RUN bundle config git.allow_insecure true
RUN mkdir -p $PROJECT_HOME

# Установка основных зависимостей
RUN apt-get update \
 && apt-get install -y \
    curl \
    gnupg \
    imagemagick \
    lsb-release \
    netcat \
    locales \
    wget \
    unzip \
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

# Установка Chromium, Chromedriver и необходимых библиотек
ARG CHROMIUM_VERSION="89.0.4389.114"
ARG CHROMEDRIVER_VERSION="89.0.4389.114"

# Установка зависимостей для Chromium
RUN apt-get update \
 && apt-get install -y \
    libasound2 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libc6 \
    libcairo2 \
    libcups2 \
    libdbus-1-3 \
    libx11-xcb1 \
    libnss3 \
    libxcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libgtk-3-0 \
    libpango-1.0-0 \
    libvulkan1 \
    fonts-liberation \
    xdg-utils

# Скачивание и установка Chromium
RUN wget -q http://ftp.debian.org/debian/pool/main/c/chromium/chromium_${CHROMIUM_VERSION}-1~deb10u1_arm64.deb \
 && dpkg -i chromium_${CHROMIUM_VERSION}-1~deb10u1_arm64.deb || apt-get -f install -y \
 && rm -f chromium_${CHROMIUM_VERSION}-1~deb10u1_arm64.deb

# Скачивание и установка Chromedriver
RUN wget -q http://ftp.debian.org/debian/pool/main/c/chromium/chromium-driver_${CHROMEDRIVER_VERSION}-1~deb10u1_arm64.deb \
 && dpkg -i chromium-driver_${CHROMEDRIVER_VERSION}-1~deb10u1_arm64.deb || apt-get -f install -y \
 && rm -f chromium-driver_${CHROMEDRIVER_VERSION}-1~deb10u1_arm64.deb

# Проверка установки Chromium
RUN chromium --version

# Проверка установки Chromedriver
RUN /usr/bin/chromedriver --version

# ______________________________________________________________________________________________________________________

# Базовый образ с Node.js
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

# Development среда
FROM base_with_node AS development

# Установка зависимостей
RUN apt-get update \
 && apt-get install -y \
    build-essential \
    git \
    wget \
    gnupg \
    ca-certificates \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Установка дополнительных библиотек для разработки
RUN apt-get update \
 && apt-get install -y \
    git \
    libmagickwand-dev \
    libxslt-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ______________________________________________________________________________________________________________________

# Production билд для сборки ассетов
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

# Финальный образ для production
FROM base_with_node

ENV RAILS_ENV=production
ENV NODE_ENV=production

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

# Команда запуска
CMD ["rails", "server", "-b", "0.0.0.0"]