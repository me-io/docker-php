# Dockerfile
ARG PHP_VERSION

# http://php.net/downloads.php
FROM php:${PHP_VERSION}-fpm
MAINTAINER Mohamed Meabed <meabed@me.io>

#ENV PHP_VERSION $PHP_VERSION
ENV DEBIAN_FRONTEND noninteractive
RUN export LANG=C.UTF-8 && export LC_ALL=en_US.UTF-8

RUN echo 'deb http://http.debian.net/debian jessie-backports main' > /etc/apt/sources.list.d/jessie-backports.list

RUN apt-get update && apt-get install -y \
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
    libkrb5-dev

RUN apt-get install -t jessie-backports -y \
    libsodium18 \
    libsodium-dev

## BASE EXT
RUN docker-php-ext-install -j$(nproc) \
    iconv \
    mcrypt \
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
    zip

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-configure imap --with-imap-ssl --with-kerberos \
	&& docker-php-ext-install imap

RUN apt-get install -y \
    zip                     \
    unzip                   \
    vim                     \
    htop                    \
    git                     \
    wget                    \
    telnet                  \
    sudo                    \
    multitail               \
    zsh                     \
    net-tools               \
    mysql-client            \
    inetutils-ping          \
    psmisc                  \
    parallel


## EXTRA
# https://pecl.php.net/package-changelog.php?package=redis
ARG REDIS_VERSION
RUN pecl install redis-${REDIS_VERSION}

# https://pecl.php.net/package-changelog.php?package=mongodb
ARG MONGO_VERSION
RUN pecl install mongodb-${MONGO_VERSION}

# https://pecl.php.net/package-changelog.php?package=amqp
ARG AMQP_VERSION
RUN pecl install amqp-${AMQP_VERSION}

# https://pecl.php.net/package-changelog.php?package=libsodium
ENV VERSION_SODIUM 2.0.11
RUN pecl install libsodium-${VERSION_SODIUM}


RUN  docker-php-ext-enable redis mongodb amqp sodium

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN ln -s /usr/local/bin/php /usr/bin/php

ADD ./config/extra-config.ini /usr/local/etc/php/conf.d/docker-php-ext-extra.ini
ADD ./config/www.conf  /usr/local/etc/php-fpm.d/www.conf

WORKDIR /var/www
