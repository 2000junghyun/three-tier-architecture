output "ec2_db_asg_name" {
  value = aws_autoscaling_group.db.name
}
