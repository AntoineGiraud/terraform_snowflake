
resource "snowflake_account_role" "role_sysadmin" {
  provider = snowflake.security_admin
  name     = "${var.env_name}_ROLE_SYSADMIN"
  comment  = "owns all TLS db objects"
}

resource "snowflake_grant_account_role" "owner_has_parent" {
  provider         = snowflake.security_admin
  role_name        = snowflake_account_role.role_sysadmin.name
  parent_role_name = "SYSADMIN"
}

# grant to all usr's
resource "snowflake_grant_account_role" "grants_usr_sysadmin" {
  depends_on = [snowflake_grant_account_role.owner_has_parent]
  provider   = snowflake.security_admin
  role_name  = snowflake_account_role.role_sysadmin.name

  for_each = toset(["AGIRAUD", "FGAUDEY"])

  user_name = each.key
}
