
##############################
# 1. USAGE sur la DB pour tous les rôles
##############################
resource "snowflake_grant_privileges_to_account_role" "db_usage" {
  for_each      = toset([local.role_loader, local.role_reader])
  account_role_name = each.value
  privileges = ["USAGE"]
  on_account_object {
    object_type = "DATABASE"
    object_name = var.bdd
  }
}

##############################
# 2. Transfert d'ownership des schémas
##############################
resource "snowflake_grant_ownership" "bronze_ownership" {
  account_role_name = local.role_loader
  outbound_privileges = "REVOKE"
  on {
    object_type = "SCHEMA"
    object_name = "${var.bdd}.${var.sch_bronze}"
  }
}
resource "snowflake_grant_ownership" "silver_gold_ownership" {
  for_each      = toset([var.sch_gold, var.sch_silver])
  account_role_name = local.role_transformer
  outbound_privileges = "REVOKE"
  on {
    object_type = "SCHEMA"
    object_name = "${var.bdd}.${each.value}"
  }
}



##############################
# 3. Droits de lecture pour READER
##############################
# USAGE sur tous les schémas existants
resource "snowflake_grant_privileges_to_account_role" "reader_usage_all_schemas" {
  account_role_name = local.role_reader
  depends_on = [ snowflake_grant_ownership.bronze_ownership, snowflake_grant_ownership.silver_gold_ownership ]
  privileges   = ["USAGE"]
  on_schema {
    all_schemas_in_database = var.bdd
  }
}
resource "snowflake_grant_privileges_to_account_role" "reader_usage_future_schemas" {
  account_role_name = local.role_reader
  depends_on = [ snowflake_grant_ownership.bronze_ownership, snowflake_grant_ownership.silver_gold_ownership ]
  privileges   = ["USAGE"]
  on_schema {
    future_schemas_in_database = var.bdd
  }
}

# SELECT sur toutes les tables existantes
resource "snowflake_grant_privileges_to_account_role" "reader_select_all_tables" {
  privileges        = ["SELECT"]
  account_role_name = local.role_reader
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_database        = var.bdd
    }
  }
}
resource "snowflake_grant_privileges_to_account_role" "reader_select_future_tables" {
  privileges        = ["SELECT"]
  account_role_name = local.role_reader
  on_schema_object {
    future {
      object_type_plural = "TABLES"
      in_database        = var.bdd
    }
  }
}

# SELECT sur toutes les vues existantes
resource "snowflake_grant_privileges_to_account_role" "reader_select_all_views" {
  privileges        = ["SELECT"]
  account_role_name = local.role_reader
  on_schema_object {
    all {
      object_type_plural = "VIEWS"
      in_database        = var.bdd
    }
  }
}
resource "snowflake_grant_privileges_to_account_role" "reader_select_future_views" {
  privileges        = ["SELECT"]
  account_role_name = local.role_reader
  on_schema_object {
    future {
      object_type_plural = "VIEWS"
      in_database        = var.bdd
    }
  }
}