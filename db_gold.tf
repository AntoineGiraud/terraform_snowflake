
// -----------------------------------------------------------
// database creation (sysAdmin) & grant (securityAdmin)
// -----------------------------------------------------------

resource "snowflake_database" "db_gold" {
  name = "DB_GOLD"
}
