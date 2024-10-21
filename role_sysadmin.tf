
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

# grant to all usr's
resource "snowflake_grant_account_role" "grants_usr_sysadmin" {
  depends_on = [snowflake_grant_account_role.tlsOwner_has_parent]
  provider   = snowflake.security_admin
  role_name  = snowflake_account_role.role_tls_sysadmin.name

  for_each = toset(["AGIRAUD", "FGAUDEY"])

  user_name = each.key
}
