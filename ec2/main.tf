provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../vpc/terraform.tfstate"
  }
}

module "security" {
  source = "./security"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}

module "ec2" {
  source = "./instance"
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnet_id = data.terraform_remote_state.vpc.outputs.public_subnet_id
  ecs_sg_id = module.security.ecs_sg_id
}
