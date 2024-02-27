#!/bin/bash

cd ~/pwa

git clone https://github.com/magento/pwa-studio.git
cd ~/pwa-studio

yarn install
MAGENTO_BACKEND_URL="https://local.magento2.com/" CHECKOUT_BRAINTREE_TOKEN="sandbox_8yrzsvtm_s2bg8fs563crhqzk" yarn buildpack create-env-file packages/venia-concept

echo "Installation complete"

