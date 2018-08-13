#!/usr/bin/env bash

docker build -t tajawalcom/php-docker:7.1.14-7 .

if [[ $? != 0 ]]; then
    echo "php-docker Build failed."
    exit 1
fi

docker push tajawalcom/php-docker:7.1.14-7
