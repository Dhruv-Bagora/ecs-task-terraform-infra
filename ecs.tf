# ecs.tf
resource "aws_ecs_cluster" "main" {
  name = "ecs-cluster"
}

resource "aws_launch_configuration" "ecs" {
  name_prefix   = "ecs-launch-configuration"
  image_id       = "ami-018bf378c35021448"  
  instance_type  = "t2.medium"
  security_groups = [aws_security_group.ecs_instances.id]
  associate_public_ip_address = true
  key_name = "mumbaikey"

iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.name

  lifecycle {
    create_before_destroy = true
  }

  user_data = <<-EOF
              #!/bin/bash
              echo ECS_CLUSTER=${aws_ecs_cluster.main.name} >> /etc/ecs/ecs.config
              EOF
}

resource "aws_autoscaling_group" "ecs" {
  launch_configuration = aws_launch_configuration.ecs.id
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1
  vpc_zone_identifier  = [aws_subnet.public1.id,aws_subnet.public2.id]

  tag {
    key                 = "Name"
    value               = "ecs-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ecs.name
}
