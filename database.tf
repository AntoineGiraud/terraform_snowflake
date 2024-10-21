

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

resource "snowflake_schema" "schemas_brz" {
  database = snowflake_database.db_bronze.name

  for_each = toset(["SAGE_X3_CDC", "SAGE_X3_FULL"])

  name = each.key
}
