#!/usr/bin/env bash
docker-compose exec phpfpm /var/www/magento-installer.sh
docker-compose restart