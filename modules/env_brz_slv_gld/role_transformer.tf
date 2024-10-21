
// ---------------------------------------------
// SECURITYADMIN & role creation
// ---------------------------------------------

resource "snowflake_account_role" "role_transformer" {
  provider = snowflake.security_admin
  name     = "${var.env_name}_ROLE_TRANSFORMER"
  comment  = "Transformer can edit Silver & Gold models"
}

resource "snowflake_grant_account_role" "transformer_has_parent" {
  #   depends_on       = [snowflake_grant_ownership.db_owner, snowflake_grant_account_role.grants_usr_sysadmin]
  provider         = snowflake.security_admin
  role_name        = snowflake_account_role.role_transformer.name
  parent_role_name = snowflake_account_role.role_sysadmin.name
}

// -----------------------------------------------------------
// warehouse creation (sysAdmin) & grant (securityAdmin)
// -----------------------------------------------------------

resource "snowflake_warehouse" "wh_transformer" {
  provider       = snowflake.sys_admin
  name           = "${var.env_name}_WH_TRANSFORMER"
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
  source = "../service_account"

  providers = {
    snowflake = snowflake.security_admin
  }

  runner_name            = "${var.env_name}_DBT_RUNNER"
  default_role_name      = snowflake_account_role.role_transformer.name
  default_warehouse_name = snowflake_warehouse.wh_transformer.name
  default_database_name  = snowflake_database.db_silver.name
}

// -----------------------------------------------------------
// read on all db & schemas - grant (securityAdmin)
// -----------------------------------------------------------

module "db_rights_transformer" {
  source     = "../db_rights"
  depends_on = [snowflake_grant_ownership.db_owner_brz, snowflake_grant_ownership.db_owner_slv_gld, snowflake_grant_ownership.db_owner_brz_schemas]

  providers = {
    snowflake = snowflake.security_admin
  }

  database_name   = snowflake_database.db_bronze.name
  role_name       = snowflake_account_role.role_transformer.name
  database_rights = ["USAGE"]
  schema_rights   = ["USAGE"]
  objects_rights  = ["SELECT"]
}
