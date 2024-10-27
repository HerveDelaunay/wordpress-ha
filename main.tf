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