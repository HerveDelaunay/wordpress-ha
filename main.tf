module "vpc" {
  source = "./modules/vpc"
}

module "bastion" {
  source             = "./modules/bastion"
  depends_on         = [module.vpc]
  vpc_id             = module.vpc.vpc_id
  public_subnet_id_a = module.vpc.public_subnet_id_a
  public_subnet_id_b = module.vpc.public_subnet_id_b
}

module "nat" {
  source              = "./modules/nat"
  depends_on          = [module.vpc]
  public_subnet_id_a  = module.vpc.public_subnet_id_a
  private_subnet_id_a = module.vpc.private_subnet_id_a
  vpc_id              = module.vpc.vpc_id
  public_subnet_id_b  = module.vpc.public_subnet_id_b
  private_subnet_id_b = module.vpc.private_subnet_id_b
}

module "wordpress" {
  source                = "./modules/wordpress"
  depends_on            = [module.db]
  vpc_id                = module.vpc.vpc_id
  db_name               = module.db.db_name
  db_username           = module.db.db_username
  db_password           = module.db.db_password
  db_hostname           = module.db.db_hostname
  private_subnets       = [module.vpc.private_subnet_id_a, module.vpc.private_subnet_id_b]
  allow_private_ssh_id  = module.security.allow_private_ssh_id
  allow_public_http_id  = module.security.allow_public_http_id
  allow_all_outbound_id = module.security.allow_all_outbound_id
}

module "alb" {
  source             = "./modules/alb"
  depends_on         = [module.vpc, module.wordpress]
  public_subnet_id_a = module.vpc.public_subnet_id_a
  public_subnet_id_b = module.vpc.public_subnet_id_b
  vpc_id             = module.vpc.vpc_id
  instance_id_a      = module.wordpress.instance_id_a
  instance_id_b      = module.wordpress.instance_id_b
}

module "db" {
  source              = "./modules/database"
  depends_on          = [module.vpc, module.security]
  private_subnets_ids = [module.vpc.private_subnet_id_a, module.vpc.private_subnet_id_b]
  vpc_id              = module.vpc.vpc_id
}

module "security" {
  source     = "./modules/security"
  depends_on = [module.vpc]
  vpc_id     = module.vpc.vpc_id
}
