# 1️⃣ la BDD & les schémas
output "bdd" {
    value = snowflake_database.bdd.name
}
output "sch_bronze" {
    value = snowflake_schema.bronze.name
}
output "sch_silver" {
    value = snowflake_schema.silver.name
}
output "sch_gold" {
    value = snowflake_schema.gold.name
}


# 2️⃣ les warehouse dédiés
output "wh_loading" {
    value = snowflake_warehouse.loading.name
}
output "wh_transforming" {
    value = snowflake_warehouse.transforming.name
}
output "wh_reading" {
    value = snowflake_warehouse.reading.name
}