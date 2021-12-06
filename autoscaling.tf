resource "aws_launch_configuration" "custom-launch-config"{
   name_prefix = "custom-launch-config"
   image_id = data.aws_ami.ubuntu.id
   instance_type = "t2.micro"
   key_name         = aws_key_pair.ssh-key.key_name
   security_groups = [aws_security_group.my_security_group.id]
   user_data = <<EOF
   #!/bin/bash  
   sudo su 
   apt update -y 
   apt install httpd -y 
   systemctl start httpd 
   mkdir /var/www/html  
   echo 'Hello World' > /var/www/html/index.html
   EOF
}

resource "aws_autoscaling_group" "autoscaling_group"{
  name                      = "autoscaling_group"
  max_size                  = 5
  min_size                  = 1
  health_check_grace_period = 10
  health_check_type         = "ELB"
  force_delete              = true
  launch_configuration      = aws_launch_configuration.custom-launch-config.name
  vpc_zone_identifier       = [aws_subnet.private_subnet.id]
  lifecycle {
    create_before_destroy = true
  }
 }
  
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.id
  elb                    = aws_elb.my_elb.id
}
  
  resource "aws_autoscaling_policy" "auto_scaling_policy" {
  name                   = "auto_scaling_policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 10
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
  policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "scaling-up" {
  alarm_name          = "scaling-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
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
  cooldown               = 10
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
   
}

resource "aws_cloudwatch_metric_alarm" "scaling-down" {
  alarm_name          = "scaling-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.autoscaling_group.name
  }

  actions_enabled = true
  alarm_actions     = [aws_autoscaling_policy.auto_descaling_policy.arn]
}


