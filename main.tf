

locals {
  bdd_alias = "AGIRAUD"
}

# 1️⃣ Création de la DB et des schémas (SYSADMIN)
module "db_schema_warehouse" {
  source    = "./modules/db_schema_warehouse"
  providers = { snowflake = snowflake.sysadmin }
  alias = local.bdd_alias
}

# 2️⃣ Création des utilisateurs (USERADMIN)
module "users" {
  source    = "./modules/users"
  providers = { snowflake = snowflake.useradmin }
  alias = local.bdd_alias
}

# 3️⃣ Création des rôles & grants (SECURITYADMIN)
module "grants_roles" {
  source    = "./modules/grants_roles"
  providers = { snowflake = snowflake.securityadmin }

  # bdd & schémas
  bdd = module.db_schema_warehouse.bdd  # sert d'alias
  sch_bronze = module.db_schema_warehouse.sch_bronze
  sch_silver = module.db_schema_warehouse.sch_silver
  sch_gold = module.db_schema_warehouse.sch_gold

  # warehouse
  wh_loading = module.db_schema_warehouse.wh_loading
  wh_transforming = module.db_schema_warehouse.wh_transforming
  wh_reading = module.db_schema_warehouse.wh_reading

  # user
  usr_loader = module.users.usr_loader
  usr_transformer = module.users.usr_transformer
  usr_reader = module.users.usr_reader
}
