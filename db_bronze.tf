

// -----------------------------------
// database creation (sysAdmin)
// -----------------------------------

resource "snowflake_database" "db_bronze" {
  name = "TLS_DB_BRONZE"
}

// ------------------------------------
// schema creation (sysAdmin)
// ------------------------------------

resource "snowflake_schema" "sch_sage_x3_cdc" {
  database = snowflake_database.db_bronze.name
  name     = "SAGE_X3_CDC"
}
resource "snowflake_schema" "sch_sage_x3_full" {
  database = snowflake_database.db_bronze.name
  name     = "SAGE_X3_FULL"
}
