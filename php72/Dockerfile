# Dockerfile

# Pull base image.
FROM php:7.2.8-fpm

MAINTAINER Mohamed Meabed <meabed@tajawal.com>
# http://php.net/downloads.php
ENV PHP_MAJOR 7.2
ENV PHP_VERSION 7.2.8
ENV DEBIAN_FRONTEND noninteractive
RUN export LANG=C.UTF-8 && export LC_ALL=en_US.UTF-8

RUN echo 'deb http://http.debian.net/debian stretch-backports main' > /etc/apt/sources.list.d/stretch-backports.list
#RUN echo 'deb http://ftp.de.debian.org/debian stretch main' > /etc/apt/sources.list


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

RUN apt-get install -t stretch-backports -y \
    libsodium18 \
    libsodium-dev

## BASE EXT
RUN docker-php-ext-install -j$(nproc) \
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
        zip

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

RUN docker-php-ext-configure imap --with-imap-ssl --with-kerberos \
	&& docker-php-ext-install imap

#RUN curl -fsSL 'http://ftp.de.debian.org/debian/pool/main/libs/libsodium/libsodium18_1.0.11-1~bpo8+1_amd64.deb' -o libsodium18_1.0.11-1~bpo8+1_amd64.deb \
#    && dpkg -i libsodium18_1.0.11-1~bpo8+1_amd64.deb
#
#RUN curl -fsSL 'http://ftp.de.debian.org/debian/pool/main/libs/libsodium/libsodium-dev_1.0.11-1~bpo8+1_amd64.deb' -o libsodium-dev_1.0.11-1~bpo8+1_amd64.deb \
#    && dpkg -i libsodium-dev_1.0.11-1~bpo8+1_amd64.deb

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
ENV VERSION_REDIS 4.1.1
RUN pecl install redis-${VERSION_REDIS}

# https://pecl.php.net/package-changelog.php?package=mongodb
ENV VERSION_MONGODB 1.5.2
RUN pecl install mongodb-${VERSION_MONGODB}

# https://pecl.php.net/package-changelog.php?package=amqp
ENV VERSION_AMQP 1.9.3
RUN pecl install amqp-${VERSION_AMQP}

# https://pecl.php.net/package-changelog.php?package=libsodium
ENV VERSION_SODIUM 2.0.11
RUN pecl install libsodium-${VERSION_SODIUM}

# https://pecl.php.net/package-changelog.php?package=mcrypt
ENV VERSION_MCRYPT 1.0.1
RUN pecl install mcrypt-${VERSION_MCRYPT}

RUN  docker-php-ext-enable redis mongodb amqp sodium mcrypt


# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ADD ./config/extra-config.ini /usr/local/etc/php/conf.d/docker-php-ext-extra.ini
ADD ./config/queue.conf  /usr/local/etc/php-fpm.d/queue.conf
ADD ./config/upstream.conf  /usr/local/etc/php-fpm.d/upstream.conf
ADD ./config/www.conf  /usr/local/etc/php-fpm.d/www.conf

RUN ln -s /usr/local/bin/php /usr/bin/php

EXPOSE 9000 9001 9002 9003

WORKDIR /var/www
