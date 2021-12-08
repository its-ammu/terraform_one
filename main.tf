
/* ==================== SPECIFY PROVIDERS ==================== */

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = var.awsprofile
}

/* ==================== INSTANCES ==================== */

resource "aws_instance" "web_server_one" {
  for_each = aws_subnet.pubsub
  ami             = "ami-0ed9277fb7eb570c9"
  subnet_id       = each.value.id
  security_groups = [aws_security_group.sg.id]
  instance_type   = "t2.micro"
  key_name        = "arajkumar-presidio.pem"
  user_data       = file("startup.sh")

  tags = {
    Name  = "web_server_av"
    Owner = "arajkumar@presidio.com"
  }
}


/* ==================== RDS INSTANCE ==================== */

resource "aws_db_instance" "db" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "db_av"
  db_subnet_group_name = aws_db_subnet_group.db_subgrp.name
  security_group_names = [aws_security_group.rds_sg.name]
  username             = var.dbuser
  password             = var.dbpass
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true

  tags = {
    Name  = "db_av"
    Owner = "arajkumar@presidio.com"
  }
}

/* ==================== APPLICATION LOAD BALANCER ==================== */

