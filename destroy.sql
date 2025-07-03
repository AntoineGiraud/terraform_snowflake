----------------------
-- drop all
----------------------
USE ROLE accountadmin;

-- prod
-------------------------------------------------------
drop role if exists tls_role_analyst;
drop role if exists tls_role_loader;
drop role if exists tls_role_reader;
drop role if exists tls_role_reader_gold;
drop role if exists tls_role_transformer;
drop role if exists tls_role_sysadmin;

drop user if exists TLS_CATALOG_RUNNER;
drop user if exists TLS_CDC_RUNNER;
drop user if exists TLS_DBT_RUNNER;

drop database if exists tls_db_bronze cascade;
drop database if exists tls_db_silver cascade;
drop database if exists tls_db_gold cascade;

drop warehouse if exists tls_wh_analyst;
drop warehouse if exists tls_wh_loader;
drop warehouse if exists tls_wh_reader;
drop warehouse if exists tls_wh_transformer;

-- dev
-------------------------------------------------------
drop role if exists tls_dev_role_analyst;
drop role if exists tls_dev_role_loader;
drop role if exists tls_dev_role_reader;
drop role if exists tls_dev_role_reader_gold;
drop role if exists tls_dev_role_transformer;
drop role if exists tls_dev_role_sysadmin;

drop user if exists TLS_dev_CATALOG_RUNNER;
drop user if exists TLS_dev_CDC_RUNNER;
drop user if exists TLS_dev_DBT_RUNNER;

drop database if exists tls_dev_db_bronze cascade;
drop database if exists tls_dev_db_silver cascade;
drop database if exists tls_dev_db_gold cascade;

drop warehouse if exists tls_dev_wh_analyst;
drop warehouse if exists tls_dev_wh_loader;
drop warehouse if exists tls_dev_wh_reader;
drop warehouse if exists tls_dev_wh_transformer;
