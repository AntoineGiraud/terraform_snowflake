terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.87"
    }
  }
}

# ------------------------------------
# databases
# ------------------------------------
resource "snowflake_grant_privileges_to_account_role" "database_grant" {
  privileges        = var.database_rights
  account_role_name = var.role_name
  on_account_object {
    object_type = "DATABASE"
    object_name = var.database_name
  }
}

# ------------------------------------
# schemas
# ------------------------------------
resource "snowflake_grant_privileges_to_account_role" "schema_grant_all" {
  privileges        = var.schema_rights
  account_role_name = var.role_name
  on_schema {
    # schema_name = "${var.database_name}.${snowflake_schema.sch_sage_x3_cdc.name}"
    all_schemas_in_database = var.database_name
  }
}

resource "snowflake_grant_privileges_to_account_role" "schema_grant_future" {
  privileges        = var.schema_rights
  account_role_name = var.role_name
  on_schema {
    future_schemas_in_database = var.database_name
  }
}

# ------------------------------------
# tables
# ------------------------------------
resource "snowflake_grant_privileges_to_account_role" "table_grant_all" {
  privileges        = var.objects_rights
  account_role_name = var.role_name
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_database        = var.database_name
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "table_grant_future" {
  privileges        = var.objects_rights
  account_role_name = var.role_name
  on_schema_object {
    future {
      object_type_plural = "TABLES"
      in_database        = var.database_name
    }
  }
}

# ------------------------------------
# views
# ------------------------------------
resource "snowflake_grant_privileges_to_account_role" "view_grant_all" {
  privileges        = var.objects_rights
  account_role_name = var.role_name
  on_schema_object {
    all {
      object_type_plural = "VIEWS"
      in_database        = var.database_name
    }
  }
}

resource "snowflake_grant_privileges_to_account_role" "view_grant_future" {
  privileges        = var.objects_rights
  account_role_name = var.role_name
  on_schema_object {
    future {
      object_type_plural = "VIEWS"
      in_database        = var.database_name
    }
  }
}
