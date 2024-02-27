#!/usr/bin/env bash
function get_ips() {
    ip a | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'
}
if [ $# -eq 0 ]; then
    ips=( $(get_ips))
    PS3='Please, tell xdebug which ip to use: '
    select opt in "${ips[@]}"; do
        selected=$opt
        break;
    done
else
    selected=$1
fi

echo selected ip $selected
sed -i 's/{place_you_ip}/'$selected'/g' ./docker-compose.yml
sed -i 's/{place_you_ip}/'$selected'/g' ./images/php/7.0/conf/php.ini
sed -i 's/{place_you_ip}/'$selected'/g' ./images/php/7.1/conf/php.ini
sed -i 's/{place_you_ip}/'$selected'/g' ./images/php/7.2/conf/php.ini
sed -i 's/{place_you_ip}/'$selected'/g' ./images/php/7.3/conf/php.ini
sed -i 's/{place_you_ip}/'$selected'/g' ./images/php/7.4/conf/php.ini
./bin/rebuild.sh