# Используем актуальный образ Ruby
FROM ruby:3.4.2-slim AS base

LABEL maintainer="Maksym Pugach <pugach.m@gmail.com>"

ENV APP_USER=app
ENV APP_HOME=/home/${APP_USER}
ENV PROJECT_HOME=${APP_HOME}/students_crm

# Обновляем RubyGems и Bundler
RUN gem update --system
RUN gem install bundler:2.6.5
RUN bundle config git.allow_insecure true

# Создаем директорию проекта
RUN mkdir -p $PROJECT_HOME

# Устанавливаем основные зависимости
RUN apt-get update \
 && apt-get install -y \
    curl \
    gnupg \
    imagemagick \
    lsb-release \
    netcat-openbsd \
    locales \
    libpq-dev \
    postgresql-client \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Устанавливаем локаль
RUN localedef -i uk_UA -c -f UTF-8 -A /usr/share/locale/locale.alias uk_UA.UTF-8
ENV LANG=uk_UA.utf8

WORKDIR $PROJECT_HOME

# ______________________________________________________________________________________________________________________

FROM base AS base_with_node

ARG NODE_LTS_VERSION=20
ARG NPM_VERSION=latest

ENV NG_CLI_ANALYTICS=false

# Устанавливаем Node.js LTS
RUN apt-get update \
 && apt-get install -y curl \
 && curl -fsSL https://deb.nodesource.com/setup_${NODE_LTS_VERSION}.x | bash - \
 && apt-get install -y nodejs \
 && npm install -g npm@${NPM_VERSION} \
 && apt-get remove --purge -y curl \
 && apt autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ______________________________________________________________________________________________________________________

FROM base_with_node AS development

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

RUN apt-get update \
 && apt-get install -y \
    build-essential \
    git \
    libmagickwand-dev

# Клонируем репозиторий
RUN git clone -b ${GIT_BRANCH} ${GIT_REPO} .

# Устанавливаем зависимости без dev и test групп
RUN bundle install -j5 --retry 10 --without development test
RUN npm install
RUN cd client && npm install && cd ..

COPY .env .env

# Компиляция ассетов
RUN export $(cat .env | grep -v "# NOTE:" | xargs) && bundle exec rake assets:precompile

# Удаляем ненужные файлы для оптимизации образа
RUN rm -rf .git app/assets/javascript* app/assets/stylesheets node_modules client .env

# ______________________________________________________________________________________________________________________

FROM base_with_node

ENV RAILS_ENV=production

COPY --from=production_builder $PROJECT_HOME $PROJECT_HOME

RUN apt-get update \
 && apt-get install -y \
    build-essential \
    git \
 && bundle install -j5 --retry 10 --without assets_builder development test \
 && apt-get remove --purge -y \
    build-essential \
    git \
 && apt autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*