#!/usr/bin/env bash
SECURE_BASE_URL=$(./bin/magento config:show web/secure/base_url)
UNSECURE_BASE_URL=$(./bin/magento config:show web/unsecure/base_url)
echo ${SECURE_BASE_URL%$'\r'}
curl ${SECURE_BASE_URL%$'\r'} --insecure -I
echo ${UNSECURE_BASE_URL%$'\r'}
curl ${UNSECURE_BASE_URL%$'\r'} -I