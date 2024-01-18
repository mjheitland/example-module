module "basic" {
  source = "../../"
  # The relative path above is only for local or CICD testing, replace it with the line below in your code!
  # source = "git@git-lps.loyaltypartner.com:saas/terraform/network.git?ref=v1"

  environment_alias = var.environment_alias
  vpc_cidr          = var.vpc_cidr
}
