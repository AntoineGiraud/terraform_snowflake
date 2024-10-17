
// ---------------------------------------------
// SECURITYADMIN & role creation
// ---------------------------------------------

resource "snowflake_account_role" "role_loader" {
  provider = snowflake.security_admin
  name     = "role_loader"
  comment  = "Loader can edit bronze models"
}

resource "snowflake_grant_account_role" "loader_has_parent" {
  provider         = snowflake.security_admin
  role_name        = snowflake_account_role.role_loader.name
  parent_role_name = "SYSADMIN"
}

// -----------------------------------------------------------
// warehouse creation (sysAdmin) & grant (securityAdmin)
// -----------------------------------------------------------

resource "snowflake_warehouse" "wh_loader" {
  name           = "wh_loader"
  warehouse_size = "xsmall"
  auto_suspend   = 60
}

resource "snowflake_grant_privileges_to_account_role" "wh_grant_loader" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.role_loader.name
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.wh_loader.name
  }
}

// ---------------------------------------------
// SECURITYADMIN & add usr to group
// ---------------------------------------------

resource "tls_private_key" "key_cdc_runner" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "snowflake_user" "cdc_runner" {
  provider          = snowflake.security_admin
  name              = "cdc_runner"
  default_warehouse = snowflake_warehouse.wh_loader.name
  default_role      = snowflake_account_role.role_loader.name
  default_namespace = snowflake_database.db_bronze.name
  rsa_public_key    = substr(tls_private_key.key_cdc_runner.public_key_pem, 27, 398)
}

resource "snowflake_grant_privileges_to_account_role" "user_grant_loader" {
  provider          = snowflake.security_admin
  privileges        = ["MONITOR"]
  account_role_name = snowflake_account_role.role_loader.name
  on_account_object {
    object_type = "USER"
    object_name = snowflake_user.cdc_runner.name
  }
}

resource "snowflake_grant_account_role" "grants_usr_loader" {
  provider  = snowflake.security_admin
  role_name = snowflake_account_role.role_loader.name
  user_name = snowflake_user.cdc_runner.name
}
