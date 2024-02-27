#!/usr/bin/env bash
docker-compose exec phpfpm /var/www/magento-installer_no_composer_stage.sh
docker-compose restart