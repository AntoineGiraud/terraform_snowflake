# 1️⃣ création de la database
resource "snowflake_database" "bdd" {
  name = var.alias
}

# 2️⃣ création des schémas
resource "snowflake_schema" "bronze" {
  database = snowflake_database.bdd.name
  name     = "BRONZE"
  comment  = "🥉 stores raw data from source systems"
}

resource "snowflake_schema" "silver" {
  database = snowflake_database.bdd.name
  name     = "SILVER"
  comment  = "🥈 stores staging & intermediate data"
}

resource "snowflake_schema" "gold" {
  database = snowflake_database.bdd.name
  name     = "GOLD"
  comment  = "🥇 stores data ready for use by analysts & viz/bi tools"
}
