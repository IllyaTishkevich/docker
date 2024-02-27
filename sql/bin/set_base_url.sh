#!/usr/bin/env bash

BASE_DOMAIN="$@"

if [ -z  "$BASE_DOMAIN" ]; then
BASE_DOMAIN="local.magento2.com"
fi
echo "New base url https://$BASE_DOMAIN/"
echo "updating the table"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$MYSQL_DATABASE" <<EOF
SET SQL_SAFE_UPDATES = 0;
UPDATE core_config_data
SET
    value = 'http://$BASE_DOMAIN/'
WHERE
    path = 'web/unsecure/base_url';
UPDATE core_config_data
SET
    value = 'https://$BASE_DOMAIN/'
WHERE
    path = 'web/secure/base_url';
SET SQL_SAFE_UPDATES = 1;

INSERT INTO core_config_data (\`scope\`, \`scope_id\`, \`path\`, \`value\`)
SELECT 'default', '0', 'web/secure/base_url', 'https://$BASE_DOMAIN/' FROM (SELECT 'default', '0', 'web/secure/base_url', 'https://$BASE_DOMAIN/') AS tmp
WHERE NOT EXISTS (
    SELECT  path FROM core_config_data WHERE path = 'web/secure/base_url'
) LIMIT 1;
INSERT INTO core_config_data (\`scope\`, \`scope_id\`, \`path\`, \`value\`)
SELECT 'default', '0', 'web/secure/use_in_adminhtml', '1' FROM (SELECT 'default', '0', 'web/secure/use_in_adminhtml', '1') AS tmp
WHERE NOT EXISTS (
    SELECT  path FROM core_config_data WHERE path = 'web/secure/use_in_adminhtml'
) LIMIT 1;

EOF
echo "all done"