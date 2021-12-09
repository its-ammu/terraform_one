variable "subnet" {
  description = "Subnet ID"
  type        = list(any)
}
variable "instance_count" {
  description = "Number of instances"
  type        = number
}
variable "ami" {
  description = "AMI for the instance"
  type        = string
  default     = "ami-002068ed284fb165b"
}

variable "security_group" {
  description = "Security group to be attached"
  type        = string
}

variable "type" {
  description = "Instance type"
  type        = string
}

variable "keypair" {
  description = "Keypair for the instance"
  type        = string
}

variable "name" {
  description = "Instance name"
  type        = string
}

variable "tags" {
  description = "Tags to be added other than name"
  type        = map(string)
}

variable "dbhost" {
  description = "RDS instance address"
  type        = string
}