
variable "db_brz_slv_gld" {
  description = "Les 3 BDD"
  type        = list(string)
  default     = ["DEV", "SLV", "GLD"]
}
