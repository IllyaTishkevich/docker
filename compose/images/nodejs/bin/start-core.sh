#!/bin/bash
cd /var/www/html/vendor/scandipwa/source
#npm ci
#npm install pm2 forever -g
pm2-runtime process-core.yml
