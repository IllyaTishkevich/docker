#!/usr/bin/env bash
echo "secure base_url : "$(./bin/magento config:show web/secure/base_url)
echo "unsecure base_url : "$(./bin/magento config:show web/unsecure/base_url)
echo "admin's frontend:" $(grep frontName ./src/app/etc/env.php)