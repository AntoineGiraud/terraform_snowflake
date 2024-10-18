
resource "snowflake_account_role" "role_tls_sysadmin" {
  provider = snowflake.security_admin
  name     = "TLS_ROLE_SYSADMIN"
  comment  = "owns all TLS db objects"
}

resource "snowflake_grant_account_role" "tlsOwner_has_parent" {
  provider         = snowflake.security_admin
  role_name        = snowflake_account_role.role_tls_sysadmin.name
  parent_role_name = "SYSADMIN"
}

resource "snowflake_grant_account_role" "grants_usr_agiraud" {
  provider  = snowflake.security_admin
  role_name = snowflake_account_role.role_tls_sysadmin.name
  user_name = "AGIRAUD"
}

resource "snowflake_grant_account_role" "grants_usr_fgaudey" {
  provider  = snowflake.security_admin
  role_name = snowflake_account_role.role_tls_sysadmin.name
  user_name = "FGAUDEY"
}
