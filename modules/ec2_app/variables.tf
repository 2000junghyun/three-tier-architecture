variable "project" {}
variable "ami_id" {}
variable "instance_type" {}
variable "key_pair_name" {}
variable "user_data_path" {}
variable "app_sg_id" {}
variable "private_subnet_ids" {
  type = list(string)
}
