#!/bin/bash
cd /var/www/html/app/design/frontend/Scandiweb/pwa
npm ci
yarn pm2-runtime process.yml
