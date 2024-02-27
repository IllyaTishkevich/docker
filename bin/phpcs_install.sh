#!/usr/bin/env bash
if [ -d "./src/vendor" ];then
   ./bin/composer require --dev magento/magento-coding-standard
fi