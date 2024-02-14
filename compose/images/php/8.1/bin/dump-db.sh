#!/usr/bin/env bash
echo "starting dumping magento's 2 database"
PASSWORD="magento"
HOST="db"
PORT="3306"
USER="root"
DATABASE="magento"
DB_FILE=/var/www/html/dump.sql
#tables to ignore
ADMIN_TABLES="admin_passwords admin_system_messages admin_user admin_user_session adminnotification_inbox magento_logging_event magento_logging_event_changes"
CUSTOMER_TABLES="customer_address_entity customer_address_entity_datetime customer_address_entity_decimal customer_address_entity_int customer_address_entity_text customer_address_entity_varchar customer_entity customer_entity_datetime customer_entity_decimal customer_entity_int customer_entity_text customer_entity_varchar customer_grid_flat customer_log customer_visitor newsletter_subscriber product_alert_price product_alert_stock vault_payment_token vault_payment_token_order_payment_link wishlist wishlist_item wishlist_item_option company magento_giftcardaccount magento_customerbalance magento_customerbalance_history magento_customersegment_customer magento_reward magento_reward_history"
SALES_TABLES="sales_order sales_order_address sales_order_aggregated_created sales_order_aggregated_updated sales_order_grid sales_order_item sales_order_payment sales_order_status_history sales_order_tax sales_order_tax_item sales_invoice sales_invoice_comment sales_invoice_grid sales_invoice_item sales_invoiced_aggregated_order sales_invoiced_aggregated sales_shipment sales_shipment_comment sales_shipment_grid sales_shipment_item sales_shipment_track sales_shipping_aggregated sales_shipping_aggregated_order sales_creditmemo sales_creditmemo_comment sales_creditmemo_grid sales_creditmemo_item sales_refunded_aggregated sales_refunded_aggregated_order sales_payment_transaction sales_bestsellers_aggregated_daily sales_bestsellers_aggregated_monthly sales_bestsellers_aggregated_yearly paypal_billing_agreement paypal_billing_agreement_order paypal_payment_transaction paypal_settlement_report paypal_settlement_report_row magento_rma magento_rma_grid magento_rma_status_history magento_rma_shipping_label magento_rma_item_entity magento_sales_order_grid_archive magento_sales_creditmemo_grid_archive magento_sales_invoice_grid_archive"
QUOTES_TABLES="quote quote_address quote_address_item quote_id_mask quote_item quote_item_option quote_payment quote_shipping_rate"
LOGS_TABLES="log_url log_url_info log_visitor log_visitor_info log_visitor_online report_event report_compared_product_index report_viewed_product_aggregated_daily report_viewed_product_aggregated_monthly report_viewed_product_aggregated_yearly report_viewed_product_index"
SESSIONS_TABLES="session persistent_session"
DOTMAILER_TABLES="email_abandoned_cart email_automation email_campaign email_contact"
SEARCH_TABLES="catalogsearch_fulltext_cl catalogsearch_fulltext_scope1 catalogsearch_fulltext_scope2 search_query search_synonyms"
TFA_TABLES="msp_tfa_user_config msp_tfa_trusted"
TRADE_TABLES=$CUSTOMER_TABLES" "$SALES_TABLES" "$QUOTES_TABLES
STRIPPED_TABLES=$LOGS_TABLES" "$SESSIONS_TABLES" "$DOTMAILER_TABLES
DEVELOPMENT_TABLES=$SALES_TABLES" "$QUOTES_TABLES
IGNORED_TABLES_STRING=''
for tablename in $DEVELOPMENT_TABLES; do
    IGNORED_TABLES_STRING+=" --ignore-table=${DATABASE}.${tablename}"
done
if  [ -x "$(command -v mysqldump)" ]; then
   if  [ -x "$(command -v gzip)" ]; then
      mysqldump --force --port=${PORT} --host=${HOST} -u ${USER} -p${PASSWORD} ${DATABASE} ${IGNORED_TABLES_STRING} | gzip >${DB_FILE}.sql.gz
      mysqldump --force --no-data --port=${PORT} --host=${HOST} -u ${USER} -p${PASSWORD} ${DATABASE} ${DEVELOPMENT_TABLES} | gzip >${DB_FILE}-ign-struct.sql.gz
   else
      mysqldump --force --port=${PORT} --host=${HOST} -u ${USER} -p${PASSWORD} ${DATABASE} ${IGNORED_TABLES_STRING} >${DB_FILE}.sql.gz
      mysqldump --force --no-data --port=${PORT} --host=${HOST} -u ${USER} -p${PASSWORD} ${DATABASE} ${DEVELOPMENT_TABLES} >${DB_FILE}-ign-struct.sql.gz
   fi
else
   echo "mysqldump utility is not installed"
fi
