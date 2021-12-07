
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

resource "aws_subnet" "pubsub_one" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "27.0.1.0/24"
  availability_zone       = "us-east1b"
  map_public_ip_on_launch = true

  tags = {
    Name  = "pubsub_one_av"
    Owner = "arajkumar@presidio.com"
  }
}

resource "aws_subnet" "pubsub_two" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "27.0.2.0/24"
  availability_zone       = "us-east1c"
  map_public_ip_on_launch = true

  tags = {
    Name  = "pubsub_two_av"
    Owner = "arajkumar@presidio.com"
  }
}

/* ==================== PRIVATE SUBNETS ==================== */

resource "aws_subnet" "privsub_one" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "27.0.3.0/24"
  availability_zone       = "us-east1a"
  map_public_ip_on_launch = false

  tags = {
    Name  = "privsub_one_av"
    Owner = "arajkumar@presidio.com"
  }
}

resource "aws_subnet" "privsub_two" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "27.0.4.0/24"
  availability_zone       = "us-east1d"
  map_public_ip_on_launch = false

  tags = {
    Name  = "privsub_two_av"
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
    Name  = "pubrt_av"
    Owner = "arajkumar@presidio.com"
  }
}

resource "aws_route" "pubrt_ig" {
  route_table_id         = aws_route_table.pubrt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id

}

/* ==================== ROUTE TABLES ASSOCIATION ==================== */

resource "aws_route_table_association" "pub_one" {
  subnet_id      = aws_subnet.pubsub_one.id
  route_table_id = aws_route_table.pubrt.id
}

resource "aws_route_table_association" "pub_two" {
  subnet_id      = aws_subnet.pubsub_two.id
  route_table_id = aws_route_table.pubrt.id
}

resource "aws_route_table_association" "priv_one" {
  subnet_id      = aws_subnet.privsub_one.id
  route_table_id = aws_route_table.privrt.id
}

resource "aws_route_table_association" "priv_two" {
  subnet_id      = aws_subnet.privsub_two.id
  route_table_id = aws_route_table.privrt.id
}


/* ==================== SECURITY GROUP ==================== */

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