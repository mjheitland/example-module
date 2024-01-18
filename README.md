<!-- markdownlint-disable MD025 MD033 MD034 MD041 -->
# network

Setting up VPC, subnets etc.

<!-- BEGIN_TF_DOCS -->
## Example

### Basic

```terraform
module "basic" {
  source = "../../"
  # The relative path above is only for local or CICD testing, replace it with the line below in your code!
  # source = "git@git-lps.loyaltypartner.com:saas/terraform/network.git?ref=v1"

  environment_alias = var.environment_alias
  vpc_cidr          = var.vpc_cidr
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.17 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.17 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment_alias"></a> [environment\_alias](#input\_environment\_alias) | Alias used for Environment tag | `string` | n/a | yes |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block used for our VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tags"></a> [tags](#output\_tags) | A map of tags assigned to the resource, including those inherited from the provider default\_tags configuration block. |
| <a name="output_vpc_cidr"></a> [vpc\_cidr](#output\_vpc\_cidr) | VPC's CIDR |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC's id |
<!-- END_TF_DOCS -->

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
README.md updated successfully
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
