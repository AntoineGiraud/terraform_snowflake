
// ---------------------------------------------
// SECURITYADMIN & role creation
// ---------------------------------------------

resource "snowflake_account_role" "role_readerGold" {
  provider = snowflake.security_admin
  name     = "TLS_ROLE_READER_GOLD"
  comment  = "Reader gold can read only gold models"
}

resource "snowflake_grant_account_role" "readerGold_has_parent" {
  provider         = snowflake.security_admin
  role_name        = snowflake_account_role.role_readerGold.name
  parent_role_name = snowflake_account_role.role_reader.name
}

// -----------------------------------------------------------
// warehouse grant (securityAdmin)
// -----------------------------------------------------------

resource "snowflake_grant_privileges_to_account_role" "wh_grant_readerGold" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.role_readerGold.name
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.wh_reader.name
  }
}
