locals {
  engine                = "mysql"
  engine_version        = "8.0"
  family                = "mysql8.0"
  major_engine_version  = "8.0"
  instance_class        = "db.t3.micro"
  allocated_storage     = 5
  max_allocated_storage = 100
  port                  = 3306
}

module "allow_private_rds_sg" {

  source      = "terraform-aws-modules/security-group/aws"
  name        = "db-security-group"
  description = "Security group for db access"
  vpc_id      = var.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "rds port"
      cidr_blocks = "10.1.0.0/24"
    }
  ]

  tags = {
    Owner = "hde"
  }

}


module "master" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.4.0"

  identifier           = "wordpress-db"
  engine               = local.engine
  engine_version       = local.engine_version
  family               = local.family
  major_engine_version = local.major_engine_version
  instance_class       = local.instance_class

  allocated_storage     = local.allocated_storage
  max_allocated_storage = local.max_allocated_storage
  storage_encrypted     = false

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = local.port

  manage_master_user_password = false

  multi_az               = true
  create_db_subnet_group = true
  subnet_ids             = var.private_subnets_ids
  vpc_security_group_ids = [var.allow_private_rds_sg_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Backups are required in order to create a replica
  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Owner = "hde"
  }

}

module "replica" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.4.0"

  identifier = "wordpress-db-replica"

  replicate_source_db = module.master.db_instance_identifier

  engine               = local.engine
  engine_version       = local.engine_version
  family               = local.family
  major_engine_version = local.major_engine_version
  instance_class       = local.instance_class

  allocated_storage     = local.allocated_storage
  max_allocated_storage = local.max_allocated_storage
  storage_encrypted     = false

  port = local.port

  password                    = var.db_password
  manage_master_user_password = false

  multi_az               = false
  vpc_security_group_ids = [var.allow_private_rds_sg_id]

  maintenance_window = "Tue:00:00-Tue:03:00"
  backup_window      = "03:00-06:00"

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Owner = "hde"
  }

}
