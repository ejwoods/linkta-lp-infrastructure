provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../vpc"
}

module "security" {
  source = "./security"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source = "./instance"
  vpc_id = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id
  ecs_sg_id = module.security.ecs_sg_id
}
