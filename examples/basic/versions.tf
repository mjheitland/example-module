terraform {
  required_version = "~> 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.17" # Upgrading to the latest terraform aws provider
    }
  }

  backend "local" {}

  # backend "s3" {
  #   bucket         = "aws-tfstate-lms"
  #   key            = "lps-lms/lms-dev-test/terraform.tfstate"
  #   dynamodb_table = "terraform-statelock-lms"
  #   profile        = "lps"
  #   region         = "eu-central-1"
  # }
}

provider "aws" {
  region = var.region
  # profile = var.profile
  # assume_role {
  #   role_arn = var.role_arn
  # }
  default_tags {
    tags = {
      Environment      = var.environment_alias
      Project          = var.project
      "ops/managed-by" = "terraform"
      module           = "network/examples/basic"
    }
  }
}
