
// -----------------------------------------------------------
// database creation (sysAdmin) & grant (securityAdmin)
// -----------------------------------------------------------

resource "snowflake_database" "db_silver" {
  name = "TLS_DB_SILVER"
}
