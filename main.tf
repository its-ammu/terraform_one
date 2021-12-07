
/* ==================== SPECIFY PROVIDERS ==================== */

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  profile = var.awsprofile
}

/* ==================== INSTANCES ==================== */

resource "aws_instance" "web_server_one" {
    ami = "ami-0ed9277fb7eb570c9"
    subnet_id = aws_subnet.pubsub_one.id
    security_groups = [aws_security_group.sg.id]
    instance_type = "t2.micro"
    key_name = "arajkumar-presidio.pem"
    user_data = "${file("startup.sh")}"

    tags = {
        Name = "web_server1_av"
        Owner = "arajkumar@presidio.com"
    }

}

resource "aws_instance" "web_server_two" {
    ami = "ami-0ed9277fb7eb570c9"
    subnet_id = aws_subnet.pubsub_two.id
    security_groups = [aws_security_group.sg.id]
    instance_type = "t2.micro"
    key_name = "arajkumar-presidio.pem"
    user_data = "${file("startup.sh")}"

    tags = {
        Name = "web_server2_av"
        Owner = "arajkumar@presidio.com"
    }

}