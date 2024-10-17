

// -----------------------------------------------------------
// database creation (sysAdmin) & grant (securityAdmin)
// -----------------------------------------------------------

resource "snowflake_database" "db_bronze" {
  name = "db_bronze"
}

// -----------------------------------------------------------
// schema creation (sysAdmin) & grant (securityAdmin)
// -----------------------------------------------------------

resource "snowflake_schema" "sch_sage_x3_cdc" {
  database = snowflake_database.db_bronze.name
  name     = "sage_x3_cdc"
}
resource "snowflake_schema" "sch_sage_x3_full" {
  database = snowflake_database.db_bronze.name
  name     = "sage_x3_full"
}
