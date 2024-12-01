provider "aws" {
  region = "us-east-1"  # You can change this if needed
}
# Launch Template
resource "aws_launch_template" "example" {
  name          = "example-launch-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  security_group_names = [var.security_group_id]

  network_interfaces {
    associate_public_ip_address = true
    subnet_id                  = var.subnet_id
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "example" {
  desired_capacity     = 1
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = [var.subnet_id]
  launch_template {
    id      = aws_launch_template.example.id
    version = "$Latest"
  }

  health_check_type          = "EC2"
  health_check_grace_period = 300
  force_delete              = true
}

# CloudWatch Alarm for CPU Utilization
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "high-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 30
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.example.name
  }

  alarm_actions = [
    aws_autoscaling_policy.scale_up.arn
  ]
}

# Scaling Policy to scale up the Auto Scaling Group
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name  = aws_autoscaling_group.example.name
}

