
/* ==================== SPECIFY PROVIDERS ==================== */

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = "us-east-2"
  profile = var.awsprofile
}

/* ==================== INSTANCES ==================== */

module "ec2_web" {
  source         = "./modules/ec2"
  name           = "Web_server"
  instance_count = 2
  subnet         = [for k, v in aws_subnet.pubsub : v.id]
  security_group = aws_security_group.sg.id
  type           = "t2.micro"
  keypair        = "arajkumar"
  dbhost         = aws_db_instance.db.address

  tags = {
    createdby = "arajkumar@presidio.com"
  }
}


/* ==================== RDS INSTANCE ==================== */

resource "aws_db_instance" "db" {
  identifier             = "terraformdb-av"
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  name                   = "todo"
  db_subnet_group_name   = aws_db_subnet_group.db_subgrp.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  username               = var.dbuser
  password               = var.dbpass
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true

  tags = {
    Name  = "db_av"
    Owner = "arajkumar@presidio.com"
  }
}

/* ==================== APPLICATION LOAD BALANCER ==================== */

resource "aws_lb" "alb" {
  name               = "alb-av"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg.id]
  subnets            = [for k, v in aws_subnet.pubsub : v.id]


  tags = {
    Name  = "alb_av"
    Owner = "arajkumar@presidio.com"
  }
}

resource "aws_lb_target_group" "web_server" {
  name     = "albtg-av"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  tags = {
    Name  = "alb_av"
    Owner = "arajkumar@presidio.com"
  }
}

resource "aws_lb_target_group_attachment" "alb" {
  count            = 2
  target_group_arn = aws_lb_target_group.web_server.arn
  target_id        = module.ec2_web.instance_id[count.index]
  port             = 80
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.web_server.arn
    type             = "forward"
  }
}
