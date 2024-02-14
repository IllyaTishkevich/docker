#!/bin/bash

# Configure composer
 [ ! -z "${M2SETUP_INSTALL_DB}" ] && \
  [ ! -z "${COMPOSER_MAGENTO_USERNAME}" ] && \
    composer config --global http-basic.repo.magento.com \
        $COMPOSER_MAGENTO_USERNAME $COMPOSER_MAGENTO_PASSWORD
exec "$@"

mkdir $MAGENTO_ROOT/m2
AUTH_JSON_FILE="$(composer -g config data-dir 2>/dev/null)/auth.json"

if [ -f "$AUTH_JSON_FILE" ]; then
    # Get composer auth information into an environment variable to avoid "you need
    # to be using an interactive terminal to authenticate".
    COMPOSER_AUTH=`cat $AUTH_JSON_FILE`
fi

MAGENTO_COMMAND="/var/www/magento-command.sh"

if [ ! -f "$MAGENTO_ROOT/composer.json" ]; then
    echo "Creating Magento ($M2SETUP_VERSION) project from composer"

    composer create-project \
        --repository-url=https://repo.magento.com/ \
        magento/project-community-edition=$M2SETUP_VERSION \
        --no-interaction \
        $MAGENTO_ROOT/m2

    mv $MAGENTO_ROOT/m2/* $MAGENTO_ROOT/m2/.* $MAGENTO_ROOT/
    rm -r m2
    # Magento forces Composer to use $MAGENTO_ROOT/var/composer_home as the home directory
    # when running any Composer commands through Magento, e.g. sampledata:deploy, so copy the
    # credentials over to it to prevent Composer from asking for them again
    if [ -f "$AUTH_JSON_FILE" ]; then
        mkdir -p $MAGENTO_ROOT/var/composer_home
        cp $AUTH_JSON_FILE $MAGENTO_ROOT/var/composer_home/auth.json
    fi
else
    echo "Magento installation found in $MAGENTO_ROOT, installing composer dependenncies"
    composer --working-dir=$MAGENTO_ROOT install
fi


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
        --admin-password=$M2SETUP_ADMIN_PASSWORD"

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
    $MAGENTO_COMMAND index:reindex
    $MAGENTO_COMMAND setup:static-content:deploy
    $MAGENTO_COMMAND config:set web/secure/use_in_adminhtml 1
    $MAGENTO_COMMAND c:c


else
    echo "Skipping DB installation"
fi

echo "Installation complete"
