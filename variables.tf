
variable "snowflake_account_identifier" {
  description = "Identifiant de votre compte snowflake `xxxxxx-xxxxxx`"
  type        = string
}

variable "snowflake_user_terraform" {
  description = "User snowflake avec qui terraform réalisera les actions (a les rôles sysadmin, securityadmin)"
  type        = string
  default     = "USR_TERRAFORM"
}

variable "snowflake_user_terraform_ssh" {
  description = "Clé privée ssh de l'utilisateur terraform (ex: ~/.ssh/key_snowflake_usr_terraform)"
  type        = string
}
