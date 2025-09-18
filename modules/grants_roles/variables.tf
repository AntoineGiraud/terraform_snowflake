##############################
# Variables
##############################
variable "bdd" {
    description = "Alias de la db/environnement. il sera dans le nom des objets pour s'y repérer"
    type = string
}

variable "sch_bronze" { type = string }
variable "sch_silver" { type = string }
variable "sch_gold" { type = string }

variable "wh_loading" { type = string }
variable "wh_transforming" { type = string }
variable "wh_reading" { type = string }

variable "usr_loader" { type = string }
variable "usr_transformer" { type = string }
variable "usr_reader" { type = string }
