
// ---------------------------------------------
// SECURITYADMIN & role creation
// ---------------------------------------------

resource "snowflake_account_role" "role_reader" {
  provider = snowflake.security_admin
  name     = "role_reader"
  comment  = "Reader can read all models"
}

resource "snowflake_grant_account_role" "reader_has_parent" {
  provider         = snowflake.security_admin
  role_name        = snowflake_account_role.role_reader.name
  parent_role_name = "SYSADMIN"
}

// -----------------------------------------------------------
// warehouse creation (sysAdmin) & grant (securityAdmin)
// -----------------------------------------------------------

resource "snowflake_warehouse" "wh_reader" {
  name           = "wh_reader"
  warehouse_size = "xsmall"
  auto_suspend   = 60
}

resource "snowflake_grant_privileges_to_account_role" "wh_grant_reader" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.role_reader.name
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.wh_reader.name
  }
}


// -----------------------------------------------------------
// read on all db & schemas - grant (securityAdmin)
// -----------------------------------------------------------

# ------------------------------------
# databases
# ------------------------------------
resource "snowflake_grant_privileges_to_account_role" "db_grant_bronze_reader" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.role_reader.name
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.db_bronze.name
  }
}
resource "snowflake_grant_privileges_to_account_role" "db_grant_silver_reader" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.role_reader.name
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.db_silver.name
  }
}
resource "snowflake_grant_privileges_to_account_role" "db_grant_gold_reader" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.role_reader.name
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.db_gold.name
  }
}

# ------------------------------------
# schemas
# ------------------------------------
resource "snowflake_grant_privileges_to_account_role" "schema_grant_all_bronze_reader" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.role_reader.name
  on_schema {
    # schema_name = "${snowflake_database.db_bronze.name}.${snowflake_schema.sch_sage_x3_cdc.name}"
    all_schemas_in_database = snowflake_database.db_bronze.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "schema_grant_future_bronze_reader" {
  provider          = snowflake.security_admin
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.role_reader.name
  on_schema {
    future_schemas_in_database = snowflake_database.db_bronze.name
  }
}

# ------------------------------------
# tables
# ------------------------------------
resource "snowflake_grant_privileges_to_account_role" "table_grant_all_bronze_reader" {
  provider          = snowflake.security_admin
  privileges        = ["SELECT"]
  account_role_name = snowflake_account_role.role_reader.name
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_database        = snowflake_database.db_bronze.name
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "table_grant_future_bronze_reader" {
  provider          = snowflake.security_admin
  privileges        = ["SELECT"]
  account_role_name = snowflake_account_role.role_reader.name
  on_schema_object {
    future {
      object_type_plural = "TABLES"
      in_database        = snowflake_database.db_bronze.name
    }
  }
}

# ------------------------------------
# views
# ------------------------------------
resource "snowflake_grant_privileges_to_account_role" "view_grant_all_bronze_reader" {
  provider          = snowflake.security_admin
  privileges        = ["SELECT"]
  account_role_name = snowflake_account_role.role_reader.name
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_database        = snowflake_database.db_bronze.name
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "view_grant_future_bronze_reader" {
  provider          = snowflake.security_admin
  privileges        = ["SELECT"]
  account_role_name = snowflake_account_role.role_reader.name
  on_schema_object {
    future {
      object_type_plural = "TABLES"
      in_database        = snowflake_database.db_bronze.name
    }
  }
}
