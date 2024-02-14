<p>Описание:</p>
<p>утилита представляет собой инструмент командной строки для различных манипуляций с magento. Создать Пользователя, сделать дамп бд, создать каркас модуля в консоли разработчика (также и остальные части модуля), понизить версию модуля в бд и т.д. Все описано тут https://github.com/netz98/n98-magerun2</p>
<p>Установка: 
wget https://files.magerun.net/n98-magerun2.phar
или 
curl -O https://files.magerun.net/n98-magerun2.phar

сменить права chmod +x ./n98-magerun2.phar

проверить ./n98-magerun2.phar --version
</p>
<p>для создания урезанного дампа, можно использовать предопределенные пресеты:

@dotmailer Dotmailer data(email_abandoned_cart email_automation email_campaign email_contact)
@customers Customer data (and company data from the B2B extension)
@development Removes logs, sessions, trade data and admin users so developers do not have to work with real customer data or admin user accounts
@ee_changelog Changelog tables of new indexer since EE 1.13
@idx Tables with _idx suffix and index event tables
@log Log tables
@quotes Cart (quote) data
@sales Sales data (orders, invoices, creditmemos etc)
@search Search related tables (catalogsearch_)
@sessions Database session tables
@stripped Standard definition for a stripped dump (logs and sessions)
@trade Current trade data (customers, orders and quotes). You usually do not want those in developer systems.
Для разработки подходит пресет @development , выполнить команду нужно так 
n98-magerun2.phar db:dump --strip="@development"

пресет @development включает в себя пресеты @admin @trade @stripped @search @2fa . Т.е. исключает таблицы (по пресетам)

@admin: admin* magento_logging_event magento_logging_event_changes
@trade: log_url log_url_info log_visitor log_visitor_info log_visitor_online report_event report_compared_product_index report_viewed_*
@stripped: @log @sessions @dotmailer
@sales:  sales_order, sales_order_address sales_order_aggregated_created    sales_order_aggregated_updated sales_order_grid    sales_order_item        sales_order_payment       sales_order_status_history         sales_order_tax
            sales_order_tax_item          sales_invoice            sales_invoice_*                          sales_invoiced_*          sales_shipment            sales_shipment_*            sales_shipping_* sales_creditmemo    sales_creditmemo_*       sales_recurring_ sales_refunded_ sales_payment_*     enterprise_sales_ enterprise_customer_sales_ sales_bestsellers_     paypal_billing_agreement     paypal_payment_transaction         paypal_settlement_report magento_rma magento_rma_grid magento_rma_status_history magento_rma_shipping_label magento_rma_item_entity magento_sales_order_grid_archive magento_sales_creditmemo_grid_archive magento_sales_invoice_grid_archive magento_sales_shipment_grid_archive

@search: catalogsearch_*
    search_query      search_synonyms

@2fa: msp_tfa_user_config msp_tfa_trusted
</p>
список можно посмотреть в php-архиве n98 n98-magerun2.phar/config.yaml