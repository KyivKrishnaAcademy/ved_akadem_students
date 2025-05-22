FROM ruby:2.4.9-slim-buster AS base

LABEL maintainer="Maksym Pugach <pugach.m@gmail.com>"

ENV APP_USER=app
ENV APP_HOME=/home/${APP_USER}
ENV PROJECT_HOME=${APP_HOME}/students_crm

RUN echo "install: --no-rdoc --no-ri --no-document --suggestions" >> ~/.gemrc
RUN echo "update: --no-rdoc --no-ri --no-document --suggestions" >> ~/.gemrc
RUN gem update --system 3.2.3
RUN gem install bundler:2.3.26
RUN bundle config git.allow_insecure true
RUN mkdir -p $PROJECT_HOME

RUN apt-get update \
 && apt-get install -y \
    make \
    gcc \
    pkg-config \
    libxml2 \
    libxslt1.1 \
    openssl \
    libssl1.1 \
    ca-certificates \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    curl \
    gnupg \
    imagemagick \
    lsb-release \
    netcat \
    locales \
 && curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor > /usr/share/keyrings/postgresql.gpg \
 && echo "deb [signed-by=/usr/share/keyrings/postgresql.gpg] http://apt-archive.postgresql.org/pub/repos/apt buster-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
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
    openssl \
    libssl1.1 \
    libssl-dev \
 && sed -i 's/^openssl_conf/#openssl_conf/' /etc/ssl/openssl.cnf \
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
RUN apt-get install -y \
  libxml2 \
  libxml2-dev \
  libxslt1-dev \
  autoconf \
  automake \
  libtool \
  m4
RUN bundle config set build.nokogiri \
    --use-system-libraries \
    --with-xml2-config=/usr/bin/xml2-config \
    --with-xslt-config=/usr/bin/xslt-config \
    && bundle install -j5 --retry 10 --frozen --no-cache --without development test
RUN npm install
RUN cd client && npm install && cd ..

COPY .env .env

RUN export $(cat .env | grep -v "# NOTE:" | xargs) && bundle exec rake assets:precompile

RUN rm -rf .git app/assets/javascript* app/assets/stylesheets node_modules client .env

# ______________________________________________________________________________________________________________________

FROM base_with_node

ENV RAILS_ENV=production

COPY --from=production_builder $PROJECT_HOME/ $PROJECT_HOME/

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
