----------------------
-- drop all
----------------------
USE ROLE accountadmin;

drop role tls_role_analyst;
drop role tls_role_loader;
drop role tls_role_reader;
drop role tls_role_reader_gold;
drop role tls_role_transformer;
drop role tls_role_sysadmin;

drop user TLS_CDC_RUNNER_DEV;
drop user TLS_CDC_RUNNER_PROD;
drop user TLS_DBT_RUNNER;

drop database tls_db_bronze cascade;
drop database tls_db_silver cascade;
drop database tls_db_gold cascade;

drop warehouse tls_wh_analyst;
drop warehouse tls_wh_loader;
drop warehouse tls_wh_reader;
drop warehouse tls_wh_transformer;