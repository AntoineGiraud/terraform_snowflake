##############################
# 4. Grants sur les warehouses
##############################

resource "snowflake_grant_privileges_to_account_role" "loading_wh_all" {
  account_role_name = local.role_loader
  privileges = ["ALL PRIVILEGES"]
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = var.wh_loading
  }
}
resource "snowflake_grant_privileges_to_account_role" "transforming_wh_all" {
  account_role_name = local.role_transformer
  privileges = ["ALL PRIVILEGES"]
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = var.wh_transforming
  }
}
resource "snowflake_grant_privileges_to_account_role" "reading_wh_all" {
  account_role_name = local.role_reader
  privileges = ["ALL PRIVILEGES"]
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = var.wh_reading
  }
}
