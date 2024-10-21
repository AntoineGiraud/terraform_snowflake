variable "database_name" {
  description = "Database name"
  type        = string
}

variable "role_name" {
  description = "role name"
  type        = string
}

variable "database_rights" {
  description = "Database rights"
  type        = list(string)
  default     = ["USAGE"]
}

variable "schema_rights" {
  description = "Schema rights"
  type        = list(string)
  default     = ["USAGE"]
}

variable "objects_rights" {
  description = "Objects rights (table, views)"
  type        = list(string)
  default     = ["SELECT"]
}
