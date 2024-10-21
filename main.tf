terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.87"
    }
  }
}

# SELECT LOWER(current_organization_name() || '-' || current_account_name()) as YOUR_SNOWFLAKE_ACCOUNT;

provider "snowflake" {
  # alias         = "sys_admin"
  role          = "SYSADMIN"
  account       = "qgbwkfk-keyrus"
  user          = "AGIRAUD"
  authenticator = "JWT"
  private_key   = file("~/.ssh/keyrus/key_agiraud_snowflake")
}

# provider "snowflake" {
#   alias         = "tls_sys_admin"
#   role          = snowflake_account_role.role_tls_sysadmin.name
#   account       = "qgbwkfk-keyrus"
#   user          = "AGIRAUD"
#   authenticator = "JWT"
#   private_key   = file("~/.ssh/keyrus/key_agiraud_snowflake")
# }

provider "snowflake" {
  alias         = "security_admin"
  role          = "SECURITYADMIN"
  account       = "qgbwkfk-keyrus"
  user          = "AGIRAUD"
  authenticator = "JWT"
  private_key   = file("~/.ssh/keyrus/key_agiraud_snowflake")
}
