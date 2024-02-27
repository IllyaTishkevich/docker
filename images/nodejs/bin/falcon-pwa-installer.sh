#!/bin/bash

mkdir /home/node/pwa/deity
cd ./pwa/deity

npx create-falcon-app magento

rm /home/node/pwa/deity/magento/server/config/default.json /home/node/pwa/deity/magento/client/config/default.json

cp /home/node/falcon-data/server-config.json /home/node/pwa/deity/magento/server/config/default.json
cp /home/node/falcon-data/client-config.json /home/node/pwa/deity/magento/client/config/default.json

echo "Installation complete"

