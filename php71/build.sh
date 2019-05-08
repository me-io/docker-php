#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

REPO_NAME="meio/php"
# http://php.net/downloads.php
PHP_VERSION="7.1.29"
# https://pecl.php.net/package-changelog.php?package=redis
REDIS_VERSION="4.3.0"
# https://pecl.php.net/package-changelog.php?package=mongodb
MONGO_VERSION="1.5.3"
# https://pecl.php.net/package-changelog.php?package=amqp
AMQP_VERSION="1.9.4"

DOCKER_TAG=${PHP_VERSION}

if [[ ! -z "${DOCKER_PASSWORD}" && ! -z "${DOCKER_USERNAME}" ]]
then
    echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
fi

TAG_EXIST=`curl -s "https://hub.docker.com/v2/repositories/${REPO_NAME}/tags/${DOCKER_TAG}/" | grep '"id":'`

if [[ ! -z ${TAG_EXIST}  ]]; then
    echo "${REPO_NAME}/${DOCKER_TAG} already exist"
    exit 0
fi

docker build --build-arg PHP_VERSION=${PHP_VERSION} \
             --build-arg REDIS_VERSION=${REDIS_VERSION} \
             --build-arg MONGO_VERSION=${MONGO_VERSION} \
             --build-arg AMQP_VERSION=${AMQP_VERSION} \
             -t ${REPO_NAME}:${PHP_VERSION} ${DIR}

if [[ $? != 0 ]]; then
    echo "${REPO_NAME}/${DOCKER_TAG} build failed"
    exit 1
fi


if [[ -z ${TAG_EXIST}  ]]; then
    docker push ${REPO_NAME}:${PHP_VERSION}
    echo "${REPO_NAME}/${DOCKER_TAG} pushed successfully"
fi