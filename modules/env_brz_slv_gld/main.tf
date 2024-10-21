terraform {
  required_providers {
    snowflake = {
      source                = "Snowflake-Labs/snowflake"
      version               = "~> 0.87"
      configuration_aliases = [snowflake.security_admin, snowflake.sys_admin]
    }
  }
}
