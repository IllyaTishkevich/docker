#!/bin/bash

MAGENTO_COMMAND="/var/www/html/bin/magento"

chmod +x $MAGENTO_COMMAND

exec php $MAGENTO_COMMAND "$@"
