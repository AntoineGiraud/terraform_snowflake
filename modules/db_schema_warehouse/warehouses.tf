# 1️⃣ création d'un monitor pour ne pas exploser les budgets

# resource "snowflake_resource_monitor" "monitor_wh" {
#   name                        = "WH_MONITOR_${var.alias}"
#   credit_quota                = var.daily_credit_quota
#   frequency                   = "DAILY"
#   start_timestamp             = "IMMEDIATELY"
#   notify_triggers              = [80]
#   suspend_trigger             = 100
#   suspend_immediate_trigger   = 110
# }

# 2️⃣ création des warehouses
resource "snowflake_warehouse" "loading" {
  name                = "WH_LOADING_${var.alias}"
  warehouse_size      = "XSMALL"
  auto_suspend        = 60
  auto_resume         = true
  initially_suspended = true
  # resource_monitor    = snowflake_resource_monitor.monitor_wh.name
}

resource "snowflake_warehouse" "transforming" {
  name                = "WH_TRANSFORMING_${var.alias}"
  warehouse_size      = "XSMALL"
  auto_suspend        = 60
  auto_resume         = true
  initially_suspended = true
  # resource_monitor    = snowflake_resource_monitor.monitor_wh.name
}

resource "snowflake_warehouse" "reading" {
  name                = "WH_READING_${var.alias}"
  warehouse_size      = "XSMALL"
  auto_suspend        = 60
  auto_resume         = true
  initially_suspended = true
  # resource_monitor    = snowflake_resource_monitor.monitor_wh.name
}