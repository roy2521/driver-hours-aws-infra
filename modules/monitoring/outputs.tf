output "sns_topic_arn" {
  description = "ARN of the SNS topic used for alerts"
  value       = aws_sns_topic.alerts_topic.arn
}

output "log_group_name" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.web_logs.name
}

output "cpu_alarm_name" {
  description = "CloudWatch alarm name for High cpu"
  value       = aws_cloudwatch_metric_alarm.cpu_alarm.alarm_name
}

output "network_in_alarm_name" {
  description = "CloudWatch alarm name for High Network In"
  value       = aws_cloudwatch_metric_alarm.network_in_alarm.alarm_name
}

output "disk_read_alarm_name" {
  description = "CloudWatch alarm name for High Disk Read Bytes"
  value       = aws_cloudwatch_metric_alarm.disk_read_alarm.alarm_name
}
