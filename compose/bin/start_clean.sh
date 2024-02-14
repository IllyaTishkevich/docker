#!/usr/bin/env bash

show_magento_settings() {
    grep M2SETUP_BASE_URL ./env/magento.env
    grep M2SETUP_SECURE_BASE_URL ./env/magento.env
    grep M2SETUP_ADMIN_USER ./env/magento.env
    grep M2SETUP_ADMIN_PASSWORD ./env/magento.env
    grep M2SETUP_BACKEND_FRONTNAME ./env/magento.env
}
./bin/clear.sh

 if [ "$1" == "-s" ] || [ "$1" == "--start" ]; then
  if [ -z "$2" ]; then
    echo "Please, specify the version of magento you wants to deploy, like 'start_clean.sh -s 2.2.8' or 'start_clean.sh --start 2.3.1' ."
  else
    if [ ! -d "./src/vendor" ]; then
      echo "Starting version $2"
      docker-compose rm -f -s
      cp ./yml/$2/docker-compose.yml ./docker-compose.yml
      docker-compose -f ./docker-compose.yml -f ./docker-compose.shared.yml build
      docker-compose -f ./docker-compose.yml -f ./docker-compose.shared.yml up -d
      show_magento_settings
    else
      echo "todo help"
    fi
  fi
 fi
