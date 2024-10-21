terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.87"
    }
  }
}


// ---------------------------------------------
// SECURITYADMIN & add usr to group
// ---------------------------------------------

resource "tls_private_key" "key_service_account" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "snowflake_user" "service_account" {
  name              = var.runner_name
  default_warehouse = var.default_warehouse_name
  default_role      = var.default_role_name
  default_namespace = var.default_database_name
  rsa_public_key    = substr(tls_private_key.key_service_account.public_key_pem, 27, 398)
}

resource "snowflake_grant_privileges_to_account_role" "user_grant_loader_dev" {
  privileges        = ["MONITOR"]
  account_role_name = var.default_role_name
  on_account_object {
    object_type = "USER"
    object_name = snowflake_user.service_account.name
  }
}

resource "snowflake_grant_account_role" "grants_usr_loader_dev" {
  role_name = var.default_role_name
  user_name = snowflake_user.service_account.name
}
