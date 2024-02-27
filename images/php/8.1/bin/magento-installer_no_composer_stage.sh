#!/bin/bash

MAGENTO_COMMAND="/var/www/magento-command.sh"

if [ ! "$M2SETUP_INSTALL_DB" = "false" ]; then

    echo "Install Magento"

    INSTALL_COMMAND="$MAGENTO_COMMAND setup:install \
        --db-host=$M2SETUP_DB_HOST \
        --db-name=$M2SETUP_DB_NAME \
        --db-user=$M2SETUP_DB_USER \
        --db-password=$M2SETUP_DB_PASSWORD \
        --base-url=$M2SETUP_BASE_URL \
        --admin-firstname=$M2SETUP_ADMIN_FIRSTNAME \
        --admin-lastname=$M2SETUP_ADMIN_LASTNAME \
        --admin-email=$M2SETUP_ADMIN_EMAIL \
        --admin-user=$M2SETUP_ADMIN_USER \
        --admin-password=$M2SETUP_ADMIN_PASSWORD \
        --language=en_US --currency=USD \
        --timezone=America/Chicago \
        --use-rewrites=1 \
        --search-engine=elasticsearch7 \
        --elasticsearch-host=elasticsearch \
        --elasticsearch-port=9200"

    # Use a separate value for secure base URL, if the variable is set
    if [ -n "$M2SETUP_SECURE_BASE_URL" ]; then
        INSTALL_COMMAND="$INSTALL_COMMAND --base-url-secure=$M2SETUP_SECURE_BASE_URL"
    fi

    # Only define a backend-frontname if the variable is set, or not empty.
    if [ -n "$M2SETUP_BACKEND_FRONTNAME" ]; then
        INSTALL_COMMAND="$INSTALL_COMMAND --backend-frontname=$M2SETUP_BACKEND_FRONTNAME"
    fi

    if [ "$M2SETUP_USE_SAMPLE_DATA" = "true" ]; then

      $MAGENTO_COMMAND sampledata:deploy
      composer --working-dir=$MAGENTO_ROOT update

      INSTALL_COMMAND="$INSTALL_COMMAND --use-sample-data"
    fi

    $INSTALL_COMMAND
    if [ ! "$M2SETUP_REDIS_DEFAULT_CACHING" = "false" ]; then
       $MAGENTO_COMMAND setup:config:set --cache-backend=redis --cache-backend-redis-server=redis --cache-backend-redis-db=0
    fi
    if [ ! "$M2SETUP_REDIS_PAGE_CACHING" = "false" ]; then
       $MAGENTO_COMMAND setup:config:set --page-cache=redis --page-cache-redis-server=redis --page-cache-redis-db=1
    fi
    if [ ! "$M2SETUP_REDIS_SESSION_STORE" = "false" ]; then
       $MAGENTO_COMMAND setup:config:set --session-save=redis --session-save-redis-host=redis --session-save-redis-log-level=3 --session-save-redis-db=2
    fi
    $MAGENTO_COMMAND deploy:mode:set $M2SETUP_MODE
    $MAGENTO_COMMAND indexer:reindex
    $MAGENTO_COMMAND setup:static-content:deploy
    $MAGENTO_COMMAND config:set web/secure/use_in_adminhtml 1
    $MAGENTO_COMMAND cache:flush


else
    echo "Skipping DB installation"
fi

echo "Installation complete"
