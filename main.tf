terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.87"
    }
  }
}

# select lower(current_account_name()) as your_account_name, lower(current_organization_name()) as your_org_name;
locals {
  user              = "AGIRAUDEMO"
  account_name      = "nab96986"
  organization_name = "vqgxapg"
  private_key_path  = "~/.ssh_windows/perso/key_agiraud_snowflake"
}


provider "snowflake" {
  alias         = "sys_admin"
  role          = "SYSADMIN"
  organization_name = local.organization_name
  account_name      = local.account_name
  user          = local.user
  authenticator = "SNOWFLAKE_JWT"
  private_key       = file(local.private_key_path)
}

provider "snowflake" {
  alias         = "security_admin"
  role          = "SECURITYADMIN"
  organization_name = local.organization_name
  account_name      = local.account_name
  user          = local.user
  authenticator = "SNOWFLAKE_JWT"
  private_key       = file(local.private_key_path)
}

# --------------------------------------------------
# LET'S GOOOO
# --------------------------------------------------
module "create_env_tls" {
  source   = "./modules/env_brz_slv_gld"
  env_name = "TLS"

  providers = {
    snowflake.security_admin = snowflake.security_admin,
    snowflake.sys_admin      = snowflake.sys_admin
  }
}

module "create_env_tls_dev" {
  source   = "./modules/env_brz_slv_gld"
  env_name = "TLS_DEV"

  providers = {
    snowflake.security_admin = snowflake.security_admin,
    snowflake.sys_admin      = snowflake.sys_admin
  }
}
