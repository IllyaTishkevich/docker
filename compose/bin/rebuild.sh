#!/usr/bin/env bash
if  [ -x "$(command -v service)" ]; then
    #nginx stop
    if  [ -x "$(command -v nginx)" ]; then
        echo 'Nginx is stopping' >&2
      {
        service nginx stop
      } || {
         echo 'can,t stop Nginx, try other way' >&2
      }
    else
      echo 'Nginx is not installed, skipping' >&2
    fi
    #apache stop
    if  [ -x "$(command -v apache2)" ]; then
        echo 'Apache is stopping' >&2
      {
        service apache2 stop
      } || {
         echo 'can,t stop Apache, try other way' >&2
      }
    else
      echo 'Apache is not installed, skipping' >&2
    fi

  else
    echo 'service command is not installed, skipping' >&2
fi

docker-compose -f ./docker-compose.yml -f ./docker-compose.shared.yml build
docker-compose -f ./docker-compose.yml -f ./docker-compose.shared.yml up -d