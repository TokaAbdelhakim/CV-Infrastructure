resource "aws_launch_configuration" "custom-launch-config"{
   name = "custom-launch-config"
   image_id = data.aws_ami.ubuntu.id
   instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "autoscaling_group"{
  name                      = "autoscaling_group"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 100
  health_check_type         = "EC2"
  force_delete              = true
  launch_configuration      = aws_launch_configuration.custom-launch-config.name
  vpc_zone_identifier       = [aws_subnet.private_subnet.id]
  }
  
  resource "aws_autoscaling_policy" "auto_scaling_policy" {
  name                   = "auto_scaling_policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 100
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
  policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "scaling-up" {
  alarm_name          = "scaling-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.autoscaling_group.name
  }

  actions_enabled = true
  alarm_actions     = [aws_autoscaling_policy.auto_scaling_policy.arn]
}

  resource "aws_autoscaling_policy" "auto_descaling_policy" {
  name                   = "auto_descaling_policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 100
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
   
}

resource "aws_cloudwatch_metric_alarm" "scaling-down" {
  alarm_name          = "scaling-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.autoscaling_group.name
  }

  actions_enabled = true
  alarm_actions     = [aws_autoscaling_policy.auto_descaling_policy.arn]
}
