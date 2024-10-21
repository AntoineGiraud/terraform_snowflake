

// -----------------------------------
// database creation (sysAdmin)
// -----------------------------------

resource "snowflake_database" "db_bronze" {
  name = "TLS_DB_BRONZE"
}
resource "snowflake_database" "db_gold" {
  name = "TLS_DB_GOLD"
}
resource "snowflake_database" "db_silver" {
  name = "TLS_DB_SILVER"
}


resource "snowflake_grant_ownership" "db_owner_brz" {
  account_role_name = snowflake_account_role.role_loader.name

  on {
    object_type = "DATABASE"
    object_name = snowflake_database.db_bronze.name
  }
}

resource "snowflake_grant_ownership" "db_owner_slv_gld" {
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

// -----------------------------------
// database trf ownership (sysAdmin)
// -----------------------------------

# resource "snowflake_grant_ownership" "db_owner" {
#   account_role_name = snowflake_account_role.role_tls_sysadmin.name

#   for_each = toset([
#     snowflake_database.db_bronze.name,
#     snowflake_database.db_silver.name,
#     snowflake_database.db_gold.name
#   ])

#   on {
#     object_type = "DATABASE"
#     object_name = each.key
#   }
# }

// ------------------------------------
// schema creation (sysAdmin)
// ------------------------------------

resource "snowflake_schema" "schemas_brz_cdc" {
  database = snowflake_database.db_bronze.name
  name     = "SAGE_X3_CDC"
}
resource "snowflake_schema" "schemas_brz_full" {
  database = snowflake_database.db_bronze.name
  name     = "SAGE_X3_FULL"
}

resource "snowflake_grant_ownership" "db_owner_brz_schemas" {
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
