#####################################
#     Security Group for ALB        #
#####################################
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg-${var.env_name}"
  description = "Allow HTTP/HTTPS inbound from anywhere"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "alb-sg-${var.env_name}"
    Environment = var.env_name
  }
}

#####################################
#         Target Group              #
#####################################

resource "aws_lb_target_group" "web_tg" {
  name     = "tg-${var.env_name}"
  port     = var.target_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }

  tags = {
    Environment = var.env_name
  }
}

#####################################
#   Application Load Balancer       #
#####################################
resource "aws_lb" "web_alb" {
  name               = "alb-${var.env_name}"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnets

  enable_deletion_protection = false
  internal                   = false

  tags = {
    Name        = "alb-${var.env_name}"
    Environment = var.env_name
  }
}

#####################################
#         Listener                  #
#####################################
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}




