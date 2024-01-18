variable "environment_alias" {
  type        = string
  description = "Alias used for Environment tag"
}

# https://de.wikipedia.org/wiki/Classless_Inter-Domain_Routing
variable "vpc_cidr" {
  type        = string
  description = "CIDR block used for our VPC"
}
