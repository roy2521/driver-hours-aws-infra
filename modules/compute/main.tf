resource "aws_security_group" "web_sg" {
      name        = "web-sg-${var.env_name}"
      description = "Allow traffic from ALB only."
      vpc_id      = var.vpc_id

      ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        security_groups = [var.alb_sg_id]
      }

      egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1" # Allow all outbound traffic
        cidr_blocks = ["0.0.0.0/0"]
      }

      tags = {
        Name = "web-sg-${var.env_name}"
        Environment = var.env_name 
      }
}

data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-*"]
  }

}

resource "aws_launch_template" "web_lt" {

  name_prefix   = "web-lt-${var.env_name}"
  image_id      = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type
  key_name =  var.key_name
  user_data = base64encode(var.user_data) 

  vpc_security_group_ids = [aws_security_group.web_sg.id]
  iam_instance_profile {name = var.instance_profile_name}

  block_device_mappings {
  device_name = "/dev/xvda"

  ebs {
    volume_type = "gp3"
    delete_on_termination = true
    encrypted = true
  }
 }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name        = "app-${var.env_name}"
      Environment = var.env_name
    }
  }

}


resource "aws_autoscaling_group" "web_asg" {
  name                      = "web-asg-${var.env_name}"
  vpc_zone_identifier       =  var.private_subnet_ids
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  health_check_type         = "ELB"
  health_check_grace_period = 120

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }
 
  target_group_arns = [var.alb_target_group_arn]
  
  #############################################
  # Instance Refresh
  #############################################
  instance_refresh {
    strategy = "Rolling"
    
    preferences {
      min_healthy_percentage = 90
      instance_warmup        = 120
    }
  }
  
  tag {
    key                 = "Name"
    value               = "web-${var.env_name}"
    propagate_at_launch = true
  }

  tag {
  key                 = "Environment"
  value               = var.env_name
  propagate_at_launch = true
 }

  lifecycle {
    create_before_destroy = true
  }

}


#############################################
# Auto Scaling Policy
#############################################
resource "aws_autoscaling_policy" "cpu_target_tracking" {
  name                   = "cpu-scaling-policy-${var.env_name}"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    # Scale OUT above 60% CPU
    # Scale IN below 60%
    target_value = 60
  }
}








