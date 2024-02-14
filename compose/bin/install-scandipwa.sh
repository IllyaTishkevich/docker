#!/usr/bin/env bash

cp ./src-packed/2.3.3/scandipwa.zip ./src
cd ./src
rm ./app/etc/env.php
unzip scandipwa.zip
rm scandipwa.zip

docker-compose restart

docker-compose exec phpfpm /var/www/scandipwa-installer.sh
docker-compose restart

docker-compose exec nodejs /home/node/scandipwa-theme-installer.sh

docker-compose exec phpfpm /var/www/magento-command.sh setup:static-content:deploy -f
docker-compose exec phpfpm /var/www/magento-command.sh setup:di:compile

docker-compose restart
