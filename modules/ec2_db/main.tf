resource "aws_launch_template" "db" {
  name_prefix   = "${var.project}-ec2-db-lt-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_pair_name

  user_data = base64encode(file(var.user_data_path))

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.db_sg_id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project}-ec2-db"
    }
  }
}

resource "aws_autoscaling_group" "db" {
  name                      = "${var.project}-ec2-db-asg"
  max_size                  = 1
  min_size                  = 1
  desired_capacity          = 1
  vpc_zone_identifier       = var.private_subnet_ids

  launch_template {
    id      = aws_launch_template.db.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.project}-ec2-db"
    propagate_at_launch = true
  }
}
