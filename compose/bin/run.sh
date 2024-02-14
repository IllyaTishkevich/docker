#!/usr/bin/env bash

show_magento_settings() {
    grep M2SETUP_BASE_URL ./env/magento.env
    grep M2SETUP_SECURE_BASE_URL ./env/magento.env
    grep M2SETUP_ADMIN_USER ./env/magento.env
    grep M2SETUP_ADMIN_PASSWORD ./env/magento.env
    grep M2SETUP_BACKEND_FRONTNAME ./env/magento.env
}

proccess_yml_file() {
     if [ -d "./src/app" ]; then
      echo "Starting version $1"
      if [ -f "./$1" ]; then
         echo $1
         cp ./$1 ./docker-compose.yml
      else
           cp ./$1/docker-compose.yml ./docker-compose.yml
      fi
      docker-compose -f ./docker-compose.yml -f ./docker-compose.shared.yml build
      docker-compose -f ./docker-compose.yml -f ./docker-compose.shared.yml up -d
      show_magento_settings
     fi
}

PS3='Please, specify version of magento path to deploy. ctrl+c - to exit script '
select DIR in yml/*;
do
     echo "You picked ${DIR: +4} ($REPLY)."
     PICKED=$SUBDIR
     echo 'picked' $PICKED
     PS3='Please, specify of environment . ctrl+c - to exit script '
     select SUBDIR in $DIR/*;
     do
       echo "You picked $SUBDIR ($REPLY)."
       PICKED=$SUBDIR
       break;
     done
  break;
done
proccess_yml_file $PICKED
