resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc-cidr
  enable_dns_support   = true
}

