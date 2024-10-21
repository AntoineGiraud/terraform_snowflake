output "role_sysadmin" {
  value = snowflake_account_role.role_sysadmin.name
}
output "role_reader" {
  value = snowflake_account_role.role_reader.name
}
output "role_transformer" {
  value = snowflake_account_role.role_transformer.name
}
