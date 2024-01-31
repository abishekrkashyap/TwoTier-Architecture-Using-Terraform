
#customized ec2 instance creation template
resource "aws_launch_template" "awsLaunchTemplate" {
  name          =  "${var.projectName}-tpl"
  image_id      = var.AMI
  instance_type = var.CPU
  key_name      = var.keyName
  user_data     = filebase64("../modules/asg/config.sh")

  vpc_security_group_ids = [ var.clientSG_Id ]
  tags = {
    name = "${var.projectName}-tpl"
  }
}

resource "aws_autoscaling_group" "asg" {
  name                      = "${var.projectName}-asg" 
  max_size                  = var.maxSize
  min_size                  = var.minSize 
  desired_capacity          = var.desiredCap 
  health_check_grace_period = 300
  health_check_type         = var.asgHealthCheckType
  vpc_zone_identifier       = [var.PRI_SUB_3_A_ID,var.PRI_SUB_4_B_ID]
  target_group_arns        = [var.TG_ARN] 

  enabled_metrics = [ 
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
   ]

   metrics_granularity = "1Minute"

   launch_template {
     id      = aws_launch_template.awsLaunchTemplate.id
     version = aws_launch_template.awsLaunchTemplate.latest_version
   }
}

#Scale Up Policy

resource "aws_autoscaling_policy" "scaleUp" {
  name                   = "${var.projectName}-asg-scale-Up"                 
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1" #this increases the instance by 1
  cooldown               =  300
  policy_type            = "SimpleScaling" 
}

# scale up alarm
# alarm will trigger the ASG policy (scale/down) based on the metric (CPUUtilization), 
#comparison_operator, threshold

resource "aws_cloudwatch_metric_alarm" "scaleUpAlarm" {
  alarm_name          = "${var.projectName}-asg-scaleUp-Alarm"
  alarm_description   = "asg-scale-up-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"  # New instance will be created once CPU utilization is higher than 30 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.asg.name
  }
  actions_enabled     = true
  alarm_actions       = [aws_autoscaling_policy.scaleUp.arn]
  }