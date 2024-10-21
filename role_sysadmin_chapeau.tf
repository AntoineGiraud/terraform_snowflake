
resource "snowflake_account_role" "role_tls_sysadmin_chapeau" {
  provider = snowflake.security_admin
  name     = "TLS_ROLE_SYSADMIN_CHAPEAU"
  comment  = "owns all TLS db objects"
}

resource "snowflake_grant_account_role" "tlsOwner_has_parent_chapeau" {
  provider         = snowflake.security_admin
  role_name        = snowflake_account_role.role_tls_sysadmin_chapeau.name
  parent_role_name = "SYSADMIN"
}

# grant to all usr's
resource "snowflake_grant_account_role" "grants_usr_sysadmin_chapeau" {
  depends_on = [snowflake_grant_account_role.tlsOwner_has_parent_chapeau]
  provider   = snowflake.security_admin
  role_name  = snowflake_account_role.role_tls_sysadmin_chapeau.name

  for_each = toset(["AGIRAUD", "FGAUDEY"])

  user_name = each.key
}

resource "snowflake_grant_account_role" "tlsOwnerPrd_has_parent_chapeau" {
  provider         = snowflake.security_admin
  role_name        = module.create_env_tls.role_sysadmin
  parent_role_name = snowflake_account_role.role_tls_sysadmin_chapeau.name
}
resource "snowflake_grant_account_role" "tlsOwnerDev_has_parent_chapeau" {
  provider         = snowflake.security_admin
  role_name        = module.create_env_tls_dev.role_sysadmin
  parent_role_name = snowflake_account_role.role_tls_sysadmin_chapeau.name
}
