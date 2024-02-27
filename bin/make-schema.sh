#!/usr/bin/env bash
./bin/magento dev:urn-catalog:generate misc.xml
mv ./src/misc.xml ../.idea/
SEARCH_STRING=$(pwd)
sed -i "s%/var/www/html%${SEARCH_STRING}/src%" "../.idea/misc.xml"