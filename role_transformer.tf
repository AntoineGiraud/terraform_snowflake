
// ---------------------------------------------
// SECURITYADMIN & role creation
// ---------------------------------------------

resource "snowflake_account_role" "role_transformer" {
  provider = snowflake.security_admin
  name     = "TLS_ROLE_TRANSFORMER"
  comment  = "Transformer can edit Silver & Gold models"
}

resource "snowflake_grant_account_role" "transformer_has_parent" {
  #   depends_on       = [snowflake_grant_ownership.db_owner, snowflake_grant_account_role.grants_usr_sysadmin]
  provider         = snowflake.security_admin
  role_name        = snowflake_account_role.role_transformer.name
  parent_role_name = snowflake_account_role.role_tls_sysadmin.name
}

// -----------------------------------------------------------
// warehouse creation (sysAdmin) & grant (securityAdmin)
// -----------------------------------------------------------

resource "snowflake_warehouse" "wh_transformer" {
  name           = "TLS_WH_TRANSFORMER"
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
// add service account
// ---------------------------------------------

module "transformer_create_runner" {
  source = "./modules/service_account"

  providers = {
    snowflake = snowflake.security_admin
  }

  runner_name            = "TLS_DBT_RUNNER"
  default_role_name      = snowflake_account_role.role_loader.name
  default_warehouse_name = snowflake_warehouse.wh_transformer.name
  default_database_name  = snowflake_database.db_silver.name
}
