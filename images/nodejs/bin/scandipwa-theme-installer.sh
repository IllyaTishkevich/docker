#!/bin/bash

cd /var/www/html/app/design/frontend/Scandiweb/pwa
npm ci
npm run build

echo "Building finished"

