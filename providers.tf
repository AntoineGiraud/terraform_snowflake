########################################
# Providers par rôle
########################################
locals {
  snow_organisation       = split("-", var.snowflake_account_identifier)[0]
  snow_account            = split("-", var.snowflake_account_identifier)[1]
}

provider "snowflake" {
  alias             = "securityadmin"
  organization_name = local.snow_organisation
  account_name      = local.snow_account
  user              = var.snowflake_user_terraform
  authenticator     = "SNOWFLAKE_JWT"
  private_key       = file(var.snowflake_user_terraform_ssh)
  role              = "SECURITYADMIN"
}

provider "snowflake" {
  alias             = "useradmin"
  organization_name = local.snow_organisation
  account_name      = local.snow_account
  user              = var.snowflake_user_terraform
  authenticator     = "SNOWFLAKE_JWT"
  private_key       = file(var.snowflake_user_terraform_ssh)
  role              = "USERADMIN"
}

provider "snowflake" {
  alias             = "sysadmin"
  organization_name = local.snow_organisation
  account_name      = local.snow_account
  user              = var.snowflake_user_terraform
  authenticator     = "SNOWFLAKE_JWT"
  private_key       = file(var.snowflake_user_terraform_ssh)
  role              = "SYSADMIN"
}
