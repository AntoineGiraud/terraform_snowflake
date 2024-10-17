terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.87"
    }
  }
}

provider "snowflake" {
  role = "SYSADMIN"
  account = "pamagkh-kq07327"
  user = "terraform_usr"
  authenticator = "JWT"
  private_key = file("C:/Users/antoine.giraud/.ssh/om_pharma/snowflake_tf_snow_key.p8")
}

provider "snowflake" {
  alias = "security_admin"
  role = "SECURITYADMIN"
  account = "pamagkh-kq07327"
  user = "terraform_usr"
  authenticator = "JWT"
  private_key = file("C:/Users/antoine.giraud/.ssh/om_pharma/snowflake_tf_snow_key.p8")
}
