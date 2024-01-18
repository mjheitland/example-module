variable "environment_alias" {
  type        = string
  description = "Alias used for Environment tag"
  default     = "lms-dev-test"
}

variable "project" {
  type        = string
  description = "Alias used for Project tag"
  default     = "lms-saas"
}

# variable "profile" {
#   type        = string
#   description = "AWS-CLI profile used by Terraform"
#   default     = "lps"
# }

variable "region" {
  type        = string
  description = "AWS region to host all our resources"
  default     = "eu-central-1"
}

# variable "role_arn" {
#   type        = string
#   description = "AWS role assumed by Terraform"
#   default     = "arn:aws:iam::967720414056:role/sts-developer"
# }

# https://de.wikipedia.org/wiki/Classless_Inter-Domain_Routing
variable "vpc_cidr" {
  type        = string
  description = "CIDR block used for our VPC"
  default     = "172.28.32.0/20"
}
