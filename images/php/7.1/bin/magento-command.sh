#!/bin/bash

MAGENTO_COMMAND="$MAGENTO_ROOT/bin/magento"

chmod +x $MAGENTO_COMMAND

exec $MAGENTO_COMMAND "$@"
