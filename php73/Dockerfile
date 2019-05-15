# Dockerfile
ARG PHP_VERSION

# http://php.net/downloads.php
FROM php:${PHP_VERSION}-fpm
MAINTAINER Mohamed Meabed <meabed@me.io>
## EXTRA
# https://pecl.php.net/package-changelog.php?package=redis
ARG REDIS_VERSION
# https://pecl.php.net/package-changelog.php?package=mongodb
ARG MONGO_VERSION
# https://pecl.php.net/package-changelog.php?package=amqp
ARG AMQP_VERSION

# https://pecl.php.net/package-changelog.php?package=libsodium
ENV VERSION_SODIUM 2.0.21
# https://pecl.php.net/package-changelog.php?package=mcrypt
ENV VERSION_MCRYPT 1.0.2

#ENV PHP_VERSION $PHP_VERSION
ENV DEBIAN_FRONTEND noninteractive
RUN export LANG=C.UTF-8 && export LC_ALL=en_US.UTF-8

# RUN echo 'deb http://http.debian.net/debian stretch-backports main' > /etc/apt/sources.list.d/stretch-backports.list

ENV EXT_PACKAGES \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libssl-dev \
    libbz2-dev \
    libxml2-dev \
    libcurl4-gnutls-dev \
    librabbitmq-dev \
    libxslt1-dev \
    libc-client2007e-dev \
    libkrb5-dev \
    zlib1g-dev \
    libicu-dev

ENV APP_PACKAGES \
    zip \
    unzip \
    vim \
    htop \
    git \
    wget \
    telnet \
    multitail \
    zsh \
    net-tools \
    mysql-client \
    inetutils-ping \
    psmisc \
    parallel

RUN apt-get update &&\
    apt-get -qq install -y ${EXT_PACKAGES} &&\
    apt-get -qq install -y ${APP_PACKAGES} &&\
    apt-get -qq install -t stretch-backports -y \
    libsodium18 \
    libsodium-dev &&\
    docker-php-ext-install -j$(nproc) \
    iconv \
    curl \
    gd \
    json \
    opcache \
    bz2 \
    mbstring \
    soap \
    xml \
    pdo \
    pdo_mysql \
    mysqli \
    bcmath \
    xsl \
    zip &&\
    docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ &&\
    docker-php-ext-install -j$(nproc) gd &&\
    docker-php-ext-configure imap --with-imap-ssl --with-kerberos &&\
    docker-php-ext-install imap &&\
    docker-php-ext-configure intl &&\
    docker-php-ext-install intl &&\
    pecl install redis-${REDIS_VERSION} &&\
    pecl install mongodb-${MONGO_VERSION} &&\
    pecl install amqp-${AMQP_VERSION} &&\
    pecl install libsodium-${VERSION_SODIUM} &&\
    pecl install mcrypt-${VERSION_MCRYPT} &&\
    docker-php-ext-enable redis mongodb amqp sodium mcrypt &&\
#    apt-get purge --auto-remove -y ${APP_PACKAGES} ;\
#    apt-get autoremove --purge -y ;\
    apt-get clean -y ;\
#    apt-get remove -y ${EXT_PACKAGES} ;\
    rm -rf /var/lib/apt/* ;\
    rm -rf /var/lib/dpkg/info/* ;\
    rm -rf /var/lib/cache/* ;\
    rm -rf /var/lib/log/* ;\
    rm -rf /var/tmp/* ;\
    rm -rf /tmp/* ;\
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer &&\
    ln -s /usr/local/bin/php /usr/bin/php

ADD ./config/extra-config.ini /usr/local/etc/php/conf.d/docker-php-ext-extra.ini
ADD ./config/www.conf  /usr/local/etc/php-fpm.d/www.conf

WORKDIR /var/www
