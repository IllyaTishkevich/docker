#!/bin/bash

MAGENTO_COMMAND="/var/www/magento-command.sh"

composer --working-dir=$MAGENTO_ROOT require deity/falcon-magento ^5.2.0

$MAGENTO_COMMAND setup:upgrade
$MAGENTO_COMMAND setup:static-content:deploy
$MAGENTO_COMMAND config:set web/seo/use_rewrites 1
$MAGENTO_COMMAND c:c

echo "Installation complete"
