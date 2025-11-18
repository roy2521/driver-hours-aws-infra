output "waf_acl_arn" {
  description = "ARN of the created WAF Web ACL"
  value       = aws_wafv2_web_acl.web_waf.arn
}

