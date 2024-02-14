#!/usr/bin/env bash

show_magento_settings() {
    grep M2SETUP_BASE_URL ./env/magento.env
    grep M2SETUP_SECURE_BASE_URL ./env/magento.env
    SECURE_BASE_URL=$(grep M2SETUP_SECURE_BASE_URL ./env/magento.env)
    ADMIN_PATH=$(grep M2SETUP_BACKEND_FRONTNAME ./env/magento.env)
    echo "Admin panel url="${SECURE_BASE_URL//M2SETUP_SECURE_BASE_URL=/}${ADMIN_PATH//M2SETUP_BACKEND_FRONTNAME=/}
    grep M2SETUP_ADMIN_USER ./env/magento.env
    grep M2SETUP_ADMIN_PASSWORD ./env/magento.env
}
get_base_domain(){
BASE_DOMAIN="$(grep M2SETUP_BASE_URL ./env/magento.env)"
base_domain=$(echo "$BASE_DOMAIN" | sed -e 's|^[^/]*//||' -e 's|/.*$||')
}

deploy_demo() {
     echo "You picked ${DIR: +11} ($REPLY)."
     ./bin/clear.sh
     ./bin/unpack_demo.sh ${DIR: +11}
     if [ -d "./src/app" ]; then
      echo "Starting version ${DIR: +11}"
      PS3='Please, specify Docker configuration for demo. ctrl+c - to exit script '
      select SUBD in ./yml/${DIR: +11}/*;
      do
          cp $SUBD/docker-compose.yml ./docker-compose.yml
          docker-compose -f ./docker-compose.yml -f ./docker-compose.shared.yml build
          docker-compose -f ./docker-compose.yml -f ./docker-compose.shared.yml up -d
          sudo bash -c 'echo "127.0.0.1 '$base_domain'" >> /etc/hosts'
          show_magento_settings
          break;
      done
     fi
}

if [ $# -gt 0 ]; 
then
   DIR=src-packed/$1
   deploy_demo;
else
   PS3='Please, specify version of magento demo to deploy. ctrl+c - to exit script '
   select DIR in src-packed/*;
   do
     deploy_demo
     break;
   done
fi
