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


// ---------------------------------------------
// SYSADMIN & db / schema creation
// ---------------------------------------------

resource "snowflake_database" "db" {
  name = "TF_DEMO"
}

resource "snowflake_warehouse" "warehouse" {
  name           = "TF_DEMO"
  warehouse_size = "xsmall"
  auto_suspend   = 60
}

resource "snowflake_schema" "schema" {
  database   = snowflake_database.db.name
  name       = "TF_DEMO"
}

// ---------------------------------------------
// SECURITYADMIN & role creation
// ---------------------------------------------

resource "snowflake_account_role" "role" {
  provider = snowflake.security_admin
  name     = "TF_DEMO_SVC_ROLE"
}

resource "snowflake_grant_account_role" "g" {
  provider          = snowflake.security_admin
  role_name        = snowflake_account_role.role.name
  parent_role_name = "SYSADMIN"
}

// ---------------------------------------------
// SECURITYADMIN & wh grants
// ---------------------------------------------

resource "snowflake_grant_privileges_to_account_role" "warehouse_grant" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.role.name
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.warehouse.name
  }
}

// ---------------------------------------------
// SECURITYADMIN & db / wh / schema grants
// ---------------------------------------------

resource "snowflake_grant_privileges_to_account_role" "database_grant" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.role.name
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.db.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "schema_grant" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.role.name
  on_schema {
    schema_name = "\"${snowflake_database.db.name}\".\"${snowflake_schema.schema.name}\""
  }
}

// ---------------------------------------------
// SECURITYADMIN & add usr to group
// ---------------------------------------------

resource "tls_private_key" "svc_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "snowflake_user" "user" {
    provider          = snowflake.security_admin
    name              = "tf_demo_user"
    default_warehouse = snowflake_warehouse.warehouse.name
    default_role      = snowflake_account_role.role.name
    default_namespace = "${snowflake_database.db.name}.${snowflake_schema.schema.name}"
    rsa_public_key    = substr(tls_private_key.svc_key.public_key_pem, 27, 398)
}

resource "snowflake_grant_privileges_to_account_role" "user_grant" {
  provider          = snowflake.security_admin
  privileges        = ["MONITOR"]
  account_role_name = snowflake_account_role.role.name
  on_account_object {
    object_type = "USER"
    object_name = snowflake_user.user.name
  }
}

resource "snowflake_grant_account_role" "grants" {
  provider  = snowflake.security_admin
  role_name = snowflake_account_role.role.name
  user_name = snowflake_user.user.name
}
