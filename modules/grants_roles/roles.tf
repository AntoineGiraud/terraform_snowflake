

##############################
# 1️⃣ création des rôles
##############################
resource "snowflake_account_role" "admin" {
  name    = "ROLE_ADMIN_${var.bdd}"
  comment = "Admin role for this domain"
}

resource "snowflake_account_role" "loader" {
  name    = "ROLE_LOADER_${var.bdd}"
  comment = "Loads data in 🥉 bronze layer (raw data)"
}

resource "snowflake_account_role" "transformer" {
  name    = "ROLE_TRANSFORMER_${var.bdd}"
  comment = "Transforms data into silver & gold layers (🥈 staging/intermediate 🥇 datamart with dim & fct) (ex: dbt)"
}

resource "snowflake_account_role" "reader" {
  name    = "ROLE_READER_${var.bdd}"
  comment = "Reads data from all layers 🥇🥈🥉 (ex: power bi, analyste)"
}

##############################
# 2️⃣ préparer des locales pour un rémploi plus simple
##############################
locals {
  role_admin = snowflake_account_role.admin.name
  role_loader = snowflake_account_role.loader.name
  role_transformer = snowflake_account_role.transformer.name
  role_reader = snowflake_account_role.reader.name
}

##############################
# 3️⃣ Hiérarchie des roles
##############################
resource "snowflake_grant_account_role" "admin_to_sysadmin" {
  role_name = local.role_admin
  parent_role_name = "SYSADMIN"
}

# le loader & le transformer appartiennent au role admin qui appartient au sysadmin
resource "snowflake_grant_account_role" "loader_to_admin" {
  role_name = local.role_loader
  parent_role_name = local.role_admin
}

resource "snowflake_grant_account_role" "transformer_to_admin" {
  role_name = local.role_transformer
  parent_role_name = local.role_admin
}

# le role reader appartient au role transformer pour qu'il puisse lire la bronze
resource "snowflake_grant_account_role" "reader_to_transformer" {
  role_name = snowflake_account_role.reader.name
  parent_role_name = local.role_transformer
}