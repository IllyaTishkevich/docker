#!/usr/bin/env bash
if [ -z "$1"  ]; then
  echo "please, set base domain"
else
docker-compose exec db /var/sql/bin/set_base_url.sh $1
echo $2 | sudo -S bash -c 'echo "127.0.0.1 '$1'" >> /etc/hosts'
fi
