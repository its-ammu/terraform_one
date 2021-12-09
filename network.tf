
/* ==================== VPC ==================== */

resource "aws_vpc" "main" {
  cidr_block       = "27.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name  = "main_av"
    Owner = "arajkumar@presidio.com"
  }
}

/* ==================== PUBLIC SUBNETS ==================== */

resource "aws_subnet" "pubsub" {
  vpc_id                  = aws_vpc.main.id
  for_each                = var.pubsub_details
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name  = "${each.value.name}"
    Owner = "arajkumar@presidio.com"
  }
}

/* ==================== PRIVATE SUBNETS ==================== */

resource "aws_subnet" "privsub" {
  vpc_id                  = aws_vpc.main.id
  for_each                = var.privsub_details
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = {
    Name  = "${each.value.name}"
    Owner = "arajkumar@presidio.com"
  }
}

/* ==================== INTERNET GATEWAY ==================== */

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name  = "ig_av"
    Owner = "arajkumar@presidio.com"
  }
}

/* ==================== ROUTE TABLES ==================== */

resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name  = "pubrt_av"
    Owner = "arajkumar@presidio.com"
  }
}

resource "aws_route_table" "privrt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name  = "privrt_av"
    Owner = "arajkumar@presidio.com"
  }
}

resource "aws_route" "pubrt_ig" {
  route_table_id         = aws_route_table.pubrt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id

}

/* ==================== ROUTE TABLES ASSOCIATION ==================== */

resource "aws_route_table_association" "pub" {
  for_each       = aws_subnet.pubsub
  subnet_id      = each.value.id
  route_table_id = aws_route_table.pubrt.id
}

resource "aws_route_table_association" "priv_one" {
  for_each       = aws_subnet.privsub
  subnet_id      = each.value.id
  route_table_id = aws_route_table.privrt.id
}



/* ==================== SECURITY GROUPS ==================== */

resource "aws_security_group" "sg" {
  name        = "Web_server"
  description = "Security group for web server with ssh allowed"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  name   = "rds_sg"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "rds_sg"
    Owner = "arajkumar@presidio.com"
  }
}

/* ==================== DB SUBNET GROUP ==================== */

resource "aws_db_subnet_group" "db_subgrp" {
  name       = "db_subgrp_av"
  subnet_ids = [for k, v in aws_subnet.privsub : v.id]

  tags = {
    Name  = "DB private subgrp"
    Owner = "arajkumar@presidio.com"
  }
}