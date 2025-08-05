variable "project" {}
variable "vpc_id" {}
variable "public_subnet_ids" {
  type = list(string)
}
variable "sg_alb_id" {
  description = "Security Group ID for ALB"
}