resource "snowflake_service_user" "loader" {
  name              = "LOADER_${var.alias}"
  comment           = "PC d'Antoine : Asus ROG"
  # default_role      = snowflake_role.bikeshare_loader.name
  # default_warehouse = snowflake_warehouse.loading.name
  # default_namespace = "${snowflake_database.bdd.name}.${snowflake_schema.bronze.name}"
}

resource "snowflake_service_user" "transformer" {
  name              = "TRANSFORMER_${var.alias}"
  comment           = "PC d'Antoine : Asus ROG"
  # default_role      = snowflake_role.bikeshare_transformer.name
  # default_warehouse = snowflake_warehouse.transforming.name
  # default_namespace = "${snowflake_database.bdd.name}.${snowflake_schema.silver.name}"
}

resource "snowflake_service_user" "reader" {
  name              = "READER_${var.alias}"
  comment           = "PC d'Antoine : Asus ROG"
  # default_role      = snowflake_role.bikeshare_reader.name
  # default_warehouse = snowflake_warehouse.reading.name
  # default_namespace = "${snowflake_database.bdd.name}.${snowflake_schema.gold.name}"
}
