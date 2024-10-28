module "vpc" {
  source = "./modules/vpc"  
}

module "bastion" {
  source = "./modules/bastion"
  depends_on = [ module.vpc ]
  vpc_id = module.vpc.vpc_id
  public_subnet_id_a = module.vpc.public_subnet_id_a
  public_subnet_id_b = module.vpc.public_subnet_id_b
}

module "nat" {
  source = "./modules/nat"
  depends_on = [ module.vpc ] 
  public_subnet_id_a = module.vpc.public_subnet_id_a
  private_subnet_id_a = module.vpc.private_subnet_id_a
  vpc_id = module.vpc.vpc_id
  public_subnet_id_b = module.vpc.public_subnet_id_b
  private_subnet_id_b = module.vpc.private_subnet_id_b
}

module "wordpress" {
  source = "./modules/wordpress"
  depends_on = [ module.vpc ]
  vpc_id = module.vpc.vpc_id
}