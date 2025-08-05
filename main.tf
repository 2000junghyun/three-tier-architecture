# VPC & Network
module "vpc" {
  source = "./modules/vpc"

  project              = var.project
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
}

provider "aws" {
  region = "us-west-2"
}

# Security groups
module "security_group" {
  source = "./modules/security_group"

  project           = var.project
  vpc_id            = module.vpc.vpc_id
  http_access_cidr  = var.http_access_cidr
  ssh_allowed_ip    = [var.ssh_allowed_ip]  # CIDR 문자열이 아니라 list로
}

# ALB
module "alb" {
  source             = "./modules/alb"
  project            = var.project
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  sg_alb_id          = module.security_group.alb_sg_id
}

# Web tier EC2
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

module "ec2_web" {
  source = "./modules/ec2_web"
  project               = var.project
  ami_id                = data.aws_ami.ubuntu.id
  instance_type         = var.instance_type
  key_pair_name         = var.key_pair_name
  user_data_path        = var.web_user_data
  web_sg_id             = module.security_group.web_sg_id
  web_target_group_arn  = module.alb.this_target_group_arn
  public_subnet_ids     = module.vpc.public_subnet_ids
}

# App tier EC2
module "ec2_app" {
  source              = "./modules/ec2_app"
  project             = var.project
  ami_id              = data.aws_ami.ubuntu.id
  instance_type       = var.instance_type
  key_pair_name       = var.key_pair_name
  user_data_path      = var.app_user_data
  app_sg_id           = module.security_group.app_sg_id
  private_subnet_ids  = module.vpc.private_subnet_ids
}

# DB tier RDS 사용
module "rds" {
  source              = "./modules/rds"
  project             = var.project
  instance_type       = var.db_instance_type
  private_subnet_ids  = module.vpc.private_subnet_ids
  db_sg_id            = module.security_group.db_sg_id
  db_name             = var.db_name
  db_username         = var.db_username
  db_password         = var.db_password
}

# DB tier EC2 사용
module "ec2_db" {
  source              = "./modules/ec2_db"
  project             = var.project
  ami_id              = data.aws_ami.ubuntu.id
  instance_type       = var.ec2_db_instance_type
  key_pair_name       = var.key_pair_name
  user_data_path      = var.ec2_db_user_data
  db_sg_id            = module.security_group.db_sg_id
  private_subnet_ids  = module.vpc.private_subnet_ids
}
