#!/bin/bash

cd /var/www/html
chmod 777 ./bin/magento
chmod -R ugoa+rwX var vendor generated pub/static pub/media app/etc

./bin/magento setup:config:set --http-cache-hosts=varnish
./bin/magento config:set system/full_page_cache/varnish/access_list "127.0.0.1, app, nginx"
./bin/magento config:set system/full_page_cache/varnish/backend_host nginx
./bin/magento config:set system/full_page_cache/varnish/backend_port 8081
./bin/magento config:set system/full_page_cache/caching_application 2

composer require scandipwa/installer

rm /var/www/html/vendor/scandipwa/source/src/config/webmanifest.config.js
rm /var/www/html/vendor/scandipwa/source/src/config/webpack.core.config.js
rm /var/www/html/vendor/scandipwa/source/src/config/webpack.development.config.js
rm /var/www/html/vendor/scandipwa/source/.graphqlconfig

cp /var/www/webmanifest.config.js /var/www/html/vendor/scandipwa/source/src/config/webmanifest.config.js
cp /var/www/webpack.core.config.js /var/www/html/vendor/scandipwa/source/src/config/webpack.core.config.js
cp /var/www/webpack.development.config.js /var/www/html/vendor/scandipwa/source/src/config/webpack.development.config.js
cp /var/www/.graphqlconfig /var/www/html/vendor/scandipwa/source/.graphqlconfig

./bin/magento setup:upgrade

./bin/magento scandipwa:theme:bootstrap Scandiweb/pwa -n

./bin/magento setup:upgrade

echo "ScandiPWA installed"


