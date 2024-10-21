
// ---------------------------------------------
// SECURITYADMIN & role creation
// ---------------------------------------------

resource "snowflake_account_role" "role_reader" {
  provider = snowflake.security_admin
  name     = "TLS_ROLE_READER"
  comment  = "Reader can read all models"
}

resource "snowflake_grant_account_role" "reader_has_parent" {
  #   depends_on       = [snowflake_grant_ownership.db_owner, snowflake_grant_account_role.grants_usr_sysadmin]
  provider         = snowflake.security_admin
  role_name        = snowflake_account_role.role_reader.name
  parent_role_name = snowflake_account_role.role_tls_sysadmin.name
}

// -----------------------------------------------------------
// warehouse creation (sysAdmin) & grant (securityAdmin)
// -----------------------------------------------------------

resource "snowflake_warehouse" "wh_reader" {
  name           = "TLS_WH_READER"
  warehouse_size = "xsmall"
  auto_suspend   = 60
}

resource "snowflake_grant_privileges_to_account_role" "wh_grant_reader" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.role_reader.name
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.wh_reader.name
  }
}


// -----------------------------------------------------------
// read on all db & schemas - grant (securityAdmin)
// -----------------------------------------------------------

module "db_rights_reader" {
  source     = "./modules/db_rights"
  depends_on = [snowflake_grant_ownership.db_owner_brz, snowflake_grant_ownership.db_owner_slv_gld, snowflake_grant_ownership.db_owner_brz_schemas]

  for_each = toset([
    snowflake_database.db_bronze.name,
    snowflake_database.db_silver.name,
    snowflake_database.db_gold.name
  ])

  providers = {
    snowflake = snowflake.security_admin
  }

  database_name   = each.key
  role_name       = snowflake_account_role.role_reader.name
  database_rights = ["USAGE"]
  schema_rights   = ["USAGE"]
  objects_rights  = ["SELECT"]
}

// ---------------------------------------------
// add service account
// ---------------------------------------------

module "reader_create_runner" {
  source = "./modules/service_account"

  providers = {
    snowflake = snowflake.security_admin
  }

  runner_name            = "TLS_CATALOG_RUNNER"
  default_role_name      = snowflake_account_role.role_loader.name
  default_warehouse_name = snowflake_warehouse.wh_reader.name
  default_database_name  = snowflake_database.db_gold.name
}
