module "vpc" {
  source = "./modules/vpc"
}

module "bastion" {
  source                   = "./modules/bastion"
  depends_on               = [module.wordpress]
  vpc_public_subnets       = module.vpc.vpc_public_subnets_ids
  allow_public_ssh_sg_id   = module.security.allow_public_ssh_id
  allow_all_outbound_sg_id = module.security.allow_all_outbound_id
}

module "wordpress" {
  source                = "./modules/wordpress"
  depends_on            = [module.db]
  vpc_id                = module.vpc.vpc_id
  vpc_cidr_block        = module.vpc.vpc_cidr_block
  vpc_public_subnets    = module.vpc.vpc_public_subnets_ids
  db_name               = module.db.db_name
  db_username           = module.db.db_username
  db_password           = module.db.db_password
  db_hostname           = module.db.db_hostname
  private_subnets       = module.vpc.private_subnets_ids
  allow_private_ssh_id  = module.security.allow_private_ssh_id
  allow_public_http_id  = module.security.allow_public_http_id
  allow_all_outbound_id = module.security.allow_all_outbound_id
}
module "db" {
  source                  = "./modules/database"
  depends_on              = [module.security]
  private_subnets_ids     = module.vpc.private_subnets_ids
  vpc_id                  = module.vpc.vpc_id
  allow_private_rds_sg_id = module.security.allow_private_rds_id
}

module "security" {
  source     = "./modules/security"
  depends_on = [module.vpc]
  vpc_id     = module.vpc.vpc_id
}
