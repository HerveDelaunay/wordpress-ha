data "aws_availability_zones" "available" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = "main_vpc"
  cidr                 = var.vpc_cidr_block
  enable_dns_hostnames = true
  azs                  = slice(data.aws_availability_zones.available.names, 0, 2)

  public_subnets  = var.public_subnet_cidr_range
  private_subnets = var.private_subnet_cidr_range

  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  tags = {
    Owner = "hde"
  }

}
