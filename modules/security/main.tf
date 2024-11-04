module "allow_private_rds_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "db_access"
  description = "security group defining the access rules to the database"
  vpc_id      = var.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "ingress from private subnet a on port 3306"
      cidr_blocks = "10.0.1.0/24"
    },
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "ingress from private subnet b on port 3306"
      cidr_blocks = "10.0.2.0/24"
    }
  ]

  tags = {
    Owner = "hde"
  }
}
module "allow_public_ssh_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "allow_public_ssh"
  description = "Security group defining the access rules to the bastion host"
  vpc_id      = var.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ingress from wan on port 22"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Owner = "hde"
  }

}

module "allow_private_ssh_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "allow_private_ssh"
  description = "Security group for ssh access inside VPC"
  vpc_id      = var.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ingress from vpc on port 22"
      cidr_blocks = "10.0.0.0/16"
    }
  ]

  tags = {
    Owner = "hde"
  }

}

module "allow_public_http_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "allow_public_http"
  description = "Security group for public HTTP access"
  vpc_id      = var.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "ingress from wan on port 80"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Owner = "hde"
  }

}

module "allow_all_outbound_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "allow_all_outbound"
  description = "Security group allowing outbound traffic to all addresses"
  vpc_id      = var.vpc_id

  egress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 443
      protocol    = "-1"
      description = "egress to wan on port 22 to 443"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = {
    Owner = "hde"
  }
}
