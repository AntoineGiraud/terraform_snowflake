
// ---------------------------------------------
// SECURITYADMIN & role creation
// ---------------------------------------------

resource "snowflake_account_role" "role_analyst" {
  provider = snowflake.security_admin
  name     = "${var.env_name}_ROLE_ANALYST"
  comment  = "Analyst can edit silver & gold models ... except on PROD db"
}

resource "snowflake_grant_account_role" "analyst_has_parent" {
  #   depends_on       = [snowflake_grant_ownership.db_owner, snowflake_grant_account_role.grants_usr_sysadmin]
  provider         = snowflake.security_admin
  role_name        = snowflake_account_role.role_analyst.name
  parent_role_name = snowflake_account_role.role_sysadmin.name
}

// -----------------------------------------------------------
// warehouse creation (sysAdmin) & grant (securityAdmin)
// -----------------------------------------------------------

resource "snowflake_warehouse" "wh_analyst" {
  provider       = snowflake.sys_admin
  name           = "${var.env_name}_WH_ANALYST"
  warehouse_size = "xsmall"
  auto_suspend   = 60
}

resource "snowflake_grant_privileges_to_account_role" "wh_grant_analyst" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.role_analyst.name
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.wh_analyst.name
  }
}
