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
ENV VERSION_SODIUM 2.0.23
# https://pecl.php.net/package-changelog.php?package=mcrypt
ENV VERSION_MCRYPT 1.0.4

#ENV PHP_VERSION $PHP_VERSION
ENV DEBIAN_FRONTEND noninteractive
RUN export LANG=C.UTF-8 && export LC_ALL=en_US.UTF-8


ENV EXT_PACKAGES \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libwebp-dev \
    libjpeg-dev \
    libssl-dev \
    libbz2-dev \
    libxml2-dev \
    libcurl4-gnutls-dev \
    librabbitmq-dev \
    libxslt1-dev \
    libc-client2007e-dev \
    libkrb5-dev \
    zlib1g-dev \
    libicu-dev \
    libsodium-dev \
    libmagickwand-dev \
    libzip-dev \
    libonig-dev

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
    inetutils-ping \
    psmisc \
    parallel

RUN apt-get update &&\
    apt-get -qq install -y ${EXT_PACKAGES} &&\
    apt-get -qq install -y ${APP_PACKAGES} &&\
    CFLAGS="-I/usr/src/php" docker-php-ext-install \
    iconv \
    curl \
    gd \
    opcache \
    bz2 \
    mbstring \
    soap \
    xml &&\
    CFLAGS="-I/usr/src/php" docker-php-ext-install \
    pdo \
    pdo_mysql \
    mysqli \
    bcmath \
    exif \
    xsl &&\
    CFLAGS="-I/usr/src/php" docker-php-ext-install \
    ctype \
    dom \
    fileinfo \
    simplexml \
    xmlreader \
    xmlwriter \
    zip &&\
    docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp &&\
    docker-php-ext-install -j$(nproc) gd &&\
    PHP_OPENSSL=yes docker-php-ext-configure imap --with-imap-ssl --with-kerberos &&\
    docker-php-ext-install imap &&\
    docker-php-ext-configure intl &&\
    docker-php-ext-install intl &&\
    yes '' | pecl install redis-${REDIS_VERSION} &&\
    yes '' | pecl install mongodb-${MONGO_VERSION} &&\
#    yes '' | pecl install amqp-${AMQP_VERSION} &&\
    yes '' | pecl install libsodium-${VERSION_SODIUM} &&\
    yes '' | pecl install mcrypt-${VERSION_MCRYPT} &&\
#    yes '' | pecl install imagick-3.4.4 &&\
    docker-php-ext-enable redis mongodb sodium mcrypt

RUN apt-get purge --auto-remove -y ${APP_PACKAGES} ;\
    apt-get autoremove --purge -y ;\
    apt-get clean -y ;\
    apt-get remove -y ${EXT_PACKAGES} ;\
    rm -rf /var/lib/apt/* ;\
#    rm -rf /var/lib/dpkg/info/* ;\
    rm -rf /var/lib/cache/* ;\
    rm -rf /var/lib/log/* ;\
    rm -rf /var/tmp/* ;\
    rm -rf /tmp/* ;\
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer &&\
    ln -s /usr/local/bin/php /usr/bin/php &&\
    apt-get update &&\
    apt-get -qq install -y git

ADD ./config/extra-config.ini /usr/local/etc/php/conf.d/docker-php-ext-extra.ini
ADD ./config/www.conf  /usr/local/etc/php-fpm.d/www.conf

WORKDIR /var/www
