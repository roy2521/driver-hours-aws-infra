########################################
# AWS WAF - Manual Configuration
# Protects the ALB using Managed, Custom, and IP-based Rules
########################################

# Blocked IP Set
resource "aws_wafv2_ip_set" "blocked_ips" {
  name               = "blocked-ips-${var.env_name}"
  description        = "Blocked IP addresses for ${var.env_name}"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses = [
    "192.0.2.44/32",
    "203.0.113.0/24"
  ]

  # Allows IP list updates directly from the AWS Console
  # without breaking Terraform state
  lifecycle {
    ignore_changes = [addresses]
  }
}

#  Main Web ACL definition
resource "aws_wafv2_web_acl" "web_waf" {
  name        = "waf-${var.env_name}"
  description = "Web ACL protecting ALB for ${var.env_name}"
  scope       = "REGIONAL"

  # Default action — allow requests that don’t match any rules
  default_action {
    allow {}
  }

  ##############################
  # Managed Rule – Common Attacks
  ##############################
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRuleSet"
      sampled_requests_enabled   = true
    }
  }
##############################
  # Managed Rule – SQL Injection
  ##############################
  rule {
    name     = "AWSManagedRulesSQLiRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SQLiRuleSet"
      sampled_requests_enabled   = true
    }
  }

  ##############################
  # Custom Rule – Block /admin Path
  ##############################
  rule {
    name     = "BlockAdminPath"
    priority = 3

    action {
      block {}
    }

    statement {
      byte_match_statement {
        search_string = "/admin"
        field_to_match {
          uri_path {}
        }
        positional_constraint = "CONTAINS"
        text_transformation {
          priority = 0
          type     = "NONE"
        }
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockAdmin"
      sampled_requests_enabled   = true
    }
  }

  ##############################
  # Custom Rule – Block Specific IPs
  ##############################
  rule {
    name     = "BlockSpecificIPs"
    priority = 4

    action {
      block {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.blocked_ips.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "BlockedIPs"
      sampled_requests_enabled   = true
    }
  }

  ##############################
  # Visibility & Monitoring
  ##############################
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "WAF-${var.env_name}"
    sampled_requests_enabled   = true
  }

  tags = {
    Environment = var.env_name
    Service     = "WAF"
    ManagedBy   = "Terraform"
  }
} 

#  Associate the WAF Web ACL with the Application Load Balancer
resource "aws_wafv2_web_acl_association" "alb_assoc" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.web_waf.arn
}
