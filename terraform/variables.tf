variable "aws_region" {
  type        = string
  description = "Location for all resources"
  default     = "sa-east-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "mba-key-pair"
}

variable "username" {
  type        = string
  description = "The username for the local account that will be created on the two EC2 instances"
  default     = "ec2-user"
}
