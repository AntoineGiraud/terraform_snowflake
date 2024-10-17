
// -----------------------------------------------------------
// warehouse creation (sysAdmin) & grant (securityAdmin)
// -----------------------------------------------------------

resource "snowflake_warehouse" "warehouse" {
  name           = "TF_DEMO"
  warehouse_size = "xsmall"
  auto_suspend   = 60
}

resource "snowflake_grant_privileges_to_account_role" "warehouse_grant" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.role.name
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.warehouse.name
  }
}

// -----------------------------------------------------------
// database creation (sysAdmin) & grant (securityAdmin)
// -----------------------------------------------------------

resource "snowflake_database" "db" {
  name = "TF_DEMO"
}

resource "snowflake_grant_privileges_to_account_role" "database_grant" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.role.name
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.db.name
  }
}

// -----------------------------------------------------------
// schema creation (sysAdmin) & grant (securityAdmin)
// -----------------------------------------------------------

resource "snowflake_schema" "schema" {
  database = snowflake_database.db.name
  name     = "TF_DEMO"
}

resource "snowflake_grant_privileges_to_account_role" "schema_grant" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.role.name
  on_schema {
    schema_name = "${snowflake_database.db.name}.${snowflake_schema.schema.name}"
  }
}
