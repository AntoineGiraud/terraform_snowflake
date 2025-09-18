
##############################
# 5. GRANT ROLE → USER
##############################

resource "snowflake_grant_account_role" "loader_to_user" {
  role_name = local.role_loader
  user_name = var.usr_loader
}
resource "snowflake_grant_account_role" "transformer_to_user" {
  role_name = local.role_transformer
  user_name = var.usr_transformer
}
resource "snowflake_grant_account_role" "reader_to_user" {
  role_name = local.role_reader
  user_name = var.usr_reader
}