variable "alias" {
    description = "Alias de la db/environnement. il sera dans le nom des objets pour s'y repérer"
    type = string
}

variable "daily_credit_quota" {
    description = "Alias de la db/environnement. il sera dans le nom des objets pour s'y repérer"
    type = number
    default = 10
}