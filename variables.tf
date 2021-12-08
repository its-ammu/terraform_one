variable "awsprofile" {
  description = "AWS profile to execute the plan with"
  type        = string
  default     = "default"
}

variable "dbuser" {
    description = "Username for RDS"
    type = string
}

variable "dbpass" {
    description = "Password for RDS"
    type = string
}

variable "pubsub_details" {
  type = map
  default = {
      subnet_one = {
          az = "us-east-1a"
          cidr_block = "27.0.1.0/24"
          name = "pubsub_one_av"
      }
      subnet_two = {
          az = "us-east-1a"
          cidr_block = "27.0.1.0/24"
          name = "pubsub_two_av"
      }
  }
}

variable "privsub_details" {
  type = map
  default = {
      subnet_one = {
          az = "us-east-1c"
          cidr_block = "27.0.3.0/24"
          name = "privsub_one_av"
      }
      subnet_two = {
          az = "us-east-1d"
          cidr_block = "27.0.4.0/24"
          name = "privsub_two_av"
      }
  }
}
