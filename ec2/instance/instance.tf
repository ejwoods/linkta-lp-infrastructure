variable "vpc_id" {}
variable "public_subnet_id" {}
variable "ecs_sg_id" {}
variable "key_name" {
  description = "Name of the SSH key pair"
  default     = "linkta-lp-infra"
}

resource "aws_launch_template" "ecs_instance_lt" {
  name = "ecs-instance-lt"
  image_id      = "ami-01622b740380d90fe"
  instance_type = "t2.micro"
  key_name      = var.key_name
  vpc_security_group_ids = [var.ecs_sg_id]
  user_data = <<-EOF
                #!/bin/bash
                echo ECS_CLUSTER=linkta-cluster >> /etc/ecs/ecs.config
                EOF
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ECSInstance"
    }
  }
}

resource "aws_autoscaling_group" "ecs_instances" {
  desired_capacity    = 1
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = [var.public_subnet_id]
  launch_template {
    id      = aws_launch_template.ecs_instance_lt.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "ECSInstance"
    propagate_at_launch = true
  }
}
