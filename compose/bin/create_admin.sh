#!/usr/bin/env bash
ADMIN_USER="admin"
ADMIN_PASSWORD="admin123"
ADMIN_EMAIL="testmail@mail.com"
ADMIN_FIRSTNAME="Admin"
ADMIN_LASTNAME="Admin"
./bin/magento admin:user:create --admin-user="${ADMIN_USER}" --admin-password="${ADMIN_PASSWORD}" --admin-email="${ADMIN_EMAIL}" --admin-firstname="${ADMIN_FIRSTNAME}" --admin-lastname="${ADMIN_LASTNAME}"
printf '%b\n' "ADMIN USER: ${ADMIN_USER}" "ADMIN PASSWORD: ${ADMIN_PASSWORD}" "ADMIN EMAIL: ${ADMIN_EMAIL}" "ADMIN FIRSTNAME: ${ADMIN_FIRSTNAME}" "ADMIN LASTNAME: ${ADMIN_LASTNAME}"