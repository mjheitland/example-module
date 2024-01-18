<!-- markdownlint-disable MD025 MD033 MD034 MD041 -->
# network

> A basic example to set up a network with VPC, subnets etc.

<!-- BEGIN_TF_DOCS -->

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.17 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_basic"></a> [basic](#module\_basic) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment_alias"></a> [environment\_alias](#input\_environment\_alias) | Alias used for Environment tag | `string` | `"lms-dev-test"` | no |
| <a name="input_project"></a> [project](#input\_project) | Alias used for Project tag | `string` | `"lms-saas"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region to host all our resources | `string` | `"eu-central-1"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | CIDR block used for our VPC | `string` | `"172.28.32.0/20"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network"></a> [network](#output\_network) | all the outputs of network module |
<!-- END_TF_DOCS -->

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
README.md updated successfully
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
