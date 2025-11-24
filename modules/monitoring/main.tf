#########################################################
# Monitoring Module: CloudWatch + SNS
# Includes: Log Group, CPU Alarm, and Email Notifications
#########################################################

# SNS Topic for alerts
resource "aws_sns_topic" "alerts_topic" {
  name = "alerts-topic-${var.env_name}"
  tags = {
    Environment = var.env_name
    ManagedBy   = "Terraform"
  }
}

# Email subscription
resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.alerts_topic.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "web_logs" {
  name              = "/web/${var.env_name}/logs"
  retention_in_days = 14
  tags = {
    Environment = var.env_name
  }
}

# CloudWatch EC2 Log
resource "aws_cloudwatch_log_group" "user_data_logs" {
  name              = "/web/${var.env_name}/user_data"
  retention_in_days = 14

  tags = {
    Environment = var.env_name
  }
}

# CloudWatch Alarm for high CPU usage
resource "aws_cloudwatch_metric_alarm" "cpu_alarm" {
  alarm_name          = "HighCPU-${var.env_name}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alert when CPU exceeds 80%"
  alarm_actions       = [aws_sns_topic.alerts_topic.arn]
  ok_actions          = [aws_sns_topic.alerts_topic.arn]
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  tags = {
    Environment = var.env_name
  }
}

# Network In Alarm
resource "aws_cloudwatch_metric_alarm" "network_in_alarm" {
  alarm_name          = "HighNetworkIn-${var.env_name}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "NetworkIn"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 50000000 #  50 MB in 5 minutes
  alarm_description   = "Alert when incoming network traffic exceeds threshold"
  alarm_actions       = [aws_sns_topic.alerts_topic.arn]
  ok_actions          = [aws_sns_topic.alerts_topic.arn]
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  tags = {
    Environment = var.env_name
  }
}

# Disk Read Bytes Alarm
resource "aws_cloudwatch_metric_alarm" "disk_read_alarm" {
  alarm_name          = "HighDiskRead-${var.env_name}"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DiskReadBytes"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 100000000 #  100 MB in 5 minutes
  alarm_description   = "Alert when disk read exceeds threshold"
  alarm_actions       = [aws_sns_topic.alerts_topic.arn]
  ok_actions          = [aws_sns_topic.alerts_topic.arn]
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }

  tags = {
    Environment = var.env_name
  }
}


