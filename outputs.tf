output "vpc_cidr" {
  description = "VPC's CIDR"
  value       = aws_vpc.vpc.cidr_block
}
output "vpc_id" {
  description = "VPC's id"
  value       = aws_vpc.vpc.id
}
output "tags" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_vpc.vpc.tags_all
}
