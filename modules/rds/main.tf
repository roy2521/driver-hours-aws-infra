resource "aws_db_subnet_group" "db_subnets" {
  name       = "db-subnets-${var.env_name}"
  subnet_ids = var.private_subnets_ids
  tags = {
    Name = "db-subnets-${var.env_name}"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg-${var.env_name}"
  description = "Allow DB traffic from web servers"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [var.web_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg-${var.env_name}"
  }
}

         
### Read DB Credentials From AWS SSM Parameters Store ###
data "aws_ssm_parameter" "db_username" {
  name = "/${var.env_name}/rds/username"
}

data "aws_ssm_parameter" "db_password" {
  name = "/${var.env_name}/rds/password"
}


resource "aws_db_instance" "web_db" {
  identifier              = "rds-${var.env_name}"
  engine                  = "mysql"
  engine_version          = "8.0.44"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  max_allocated_storage   = 100
  multi_az                = true
  storage_encrypted       = true
  deletion_protection     = false
  storage_type            = "gp3"
  publicly_accessible     = false

  db_name                 = var.db_name
  port                    = var.db_port
  
  username                = data.aws_ssm_parameter.db_username.value
  password                = data.aws_ssm_parameter.db_password.value

  db_subnet_group_name    = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]

  skip_final_snapshot     = true
  backup_retention_period = 7

  tags = {
    Name        = "rds-${var.env_name}"
    Environment = var.env_name
  }
}

