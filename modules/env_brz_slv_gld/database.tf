

// -----------------------------------
// database creation (sysAdmin)
// -----------------------------------

resource "snowflake_database" "db_bronze" {
  provider = snowflake.sys_admin
  name     = "${var.env_name}_DB_BRONZE"
}
resource "snowflake_database" "db_gold" {
  provider = snowflake.sys_admin
  name     = "${var.env_name}_DB_GOLD"
}
resource "snowflake_database" "db_silver" {
  provider = snowflake.sys_admin
  name     = "${var.env_name}_DB_SILVER"
}


resource "snowflake_grant_ownership" "db_owner_brz" {
  provider          = snowflake.sys_admin
  account_role_name = snowflake_account_role.role_loader.name

  on {
    object_type = "DATABASE"
    object_name = snowflake_database.db_bronze.name
  }
}

resource "snowflake_grant_ownership" "db_owner_slv_gld" {
  provider          = snowflake.sys_admin
  account_role_name = snowflake_account_role.role_transformer.name

  for_each = toset([
    snowflake_database.db_silver.name,
    snowflake_database.db_gold.name
  ])

  on {
    object_type = "DATABASE"
    object_name = each.key
  }
}

// ------------------------------------
// schema creation (sysAdmin)
// ------------------------------------

resource "snowflake_schema" "schemas_brz_cdc" {
  provider = snowflake.sys_admin
  database = snowflake_database.db_bronze.name
  name     = "SAGE_X3_CDC"
}
resource "snowflake_schema" "schemas_brz_full" {
  provider = snowflake.sys_admin
  database = snowflake_database.db_bronze.name
  name     = "SAGE_X3_FULL"
}

resource "snowflake_grant_ownership" "db_owner_brz_schemas" {
  provider          = snowflake.sys_admin
  account_role_name = snowflake_account_role.role_loader.name

  for_each = toset([
    snowflake_schema.schemas_brz_cdc.name,
    snowflake_schema.schemas_brz_full.name
  ])

  on {
    object_type = "SCHEMA"
    object_name = "${snowflake_database.db_bronze.name}.${each.key}"
  }
}
