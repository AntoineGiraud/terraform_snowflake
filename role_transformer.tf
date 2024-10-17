
// ---------------------------------------------
// SECURITYADMIN & role creation
// ---------------------------------------------

resource "snowflake_account_role" "role_transformer" {
  provider = snowflake.security_admin
  name     = "role_transformer"
  comment  = "Transformer can edit Silver & Gold models"
}

resource "snowflake_grant_account_role" "transformer_has_parent" {
  provider         = snowflake.security_admin
  role_name        = snowflake_account_role.role_transformer.name
  parent_role_name = "SYSADMIN"
}

// -----------------------------------------------------------
// warehouse creation (sysAdmin) & grant (securityAdmin)
// -----------------------------------------------------------

resource "snowflake_warehouse" "wh_transformer" {
  name           = "wh_transformer"
  warehouse_size = "xsmall"
  auto_suspend   = 60
}

resource "snowflake_grant_privileges_to_account_role" "wh_grant_transformer" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.role_transformer.name
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.wh_transformer.name
  }
}

// ---------------------------------------------
// SECURITYADMIN & add usr to group
// ---------------------------------------------

resource "tls_private_key" "key_dbt_runner" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "snowflake_user" "dbt_runner" {
  provider          = snowflake.security_admin
  name              = "dbt_runner"
  default_warehouse = snowflake_warehouse.wh_transformer.name
  default_role      = snowflake_account_role.role_transformer.name
  default_namespace = snowflake_database.db_bronze.name
  rsa_public_key    = substr(tls_private_key.key_dbt_runner.public_key_pem, 27, 398)
}

resource "snowflake_grant_privileges_to_account_role" "user_grant_transformer" {
  provider          = snowflake.security_admin
  privileges        = ["MONITOR"]
  account_role_name = snowflake_account_role.role_transformer.name
  on_account_object {
    object_type = "USER"
    object_name = snowflake_user.dbt_runner.name
  }
}

resource "snowflake_grant_account_role" "grants_dbt_runner" {
  provider  = snowflake.security_admin
  role_name = snowflake_account_role.role_transformer.name
  user_name = snowflake_user.dbt_runner.name
}
