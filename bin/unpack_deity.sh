#!/usr/bin/env bash
if [ -f "./src-packed/2.3.3/deity.tgz" ]; then
    tar -zxvf ./src-packed/2.3.3/deity.tgz -C ./src
fi

./bin/magento setup:upgrade
./bin/magento config:set web/seo/use_rewrites 1
./bin/magento setup:static-content:deploy -f
./bin/magento setup:di:compile
,/bin/magento c:c
