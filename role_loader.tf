
// ---------------------------------------------
// SECURITYADMIN & role creation
// ---------------------------------------------

resource "snowflake_account_role" "role_loader" {
  provider = snowflake.security_admin
  name     = "TLS_ROLE_LOADER"
  comment  = "Loader can edit bronze models"
}

resource "snowflake_grant_account_role" "loader_has_parent" {
  provider         = snowflake.security_admin
  role_name        = snowflake_account_role.role_loader.name
  parent_role_name = snowflake_account_role.role_tls_sysadmin.name
}

// -----------------------------------------------------------
// warehouse creation (sysAdmin) & grant (securityAdmin)
// -----------------------------------------------------------

resource "snowflake_warehouse" "wh_loader" {
  name           = "TLS_WH_LOADER"
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
// add service account
// ---------------------------------------------

module "loader_create_runner" {
  source = "./modules/service_account"

  providers = {
    snowflake = snowflake.security_admin
  }

  runner_name            = "TLS_CDC_RUNNER"
  default_role_name      = snowflake_account_role.role_loader.name
  default_warehouse_name = snowflake_warehouse.wh_loader.name
  default_database_name  = snowflake_database.db_bronze.name
}
