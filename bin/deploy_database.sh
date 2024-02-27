#!/usr/bin/env bash

docker-compose exec db /var/sql/bin/deploy_dump.sh $1
