# VPC & Network
variable "project" {
  default = "three-tier"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "azs" {
  default = ["us-west-2a", "us-west-2b", "us-west-2c"]  # 3개 AZ
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]  # AZ 수와 동일
}

variable "private_subnet_cidrs" {
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]  # AZ 수와 동일
}

# Security groups
variable "http_access_cidr" {
  default = "0.0.0.0/0"
}

variable "ssh_allowed_ip" {
  description = "Allowed SSH IP"
  default     = "70.168.153.114/32"
}

# Web tier EC2
variable "instance_type" {
  default = "t3.micro"
}

variable "key_pair_name" {
  default = "three-tier-key"
}

variable "web_user_data" {
  default = "./scripts/setup_web.sh"
}

# App tier EC2
variable "app_user_data" {
  default = "./scripts/setup_app.sh"
}

# DB tier RDS 사용
variable "db_instance_type" {
  default = "db.t3.micro"
}

variable "db_name" {
  default = "appdb"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default = "Changeme123!"  # secret manager 교체
}

# DB tier EC2 사용
variable "ec2_db_user_data" {
  default = "./scripts/setup_db.sh"
}

variable "ec2_db_instance_type" {
  default = "t3.micro"
}