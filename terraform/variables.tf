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

# The username depends on the distribution of the OS of the web server
# "ec2-user" - Amazon Linux
# "ubuntu" - Ubuntu Linux
variable "username" {
  type        = string
  description = "The username for the local account that will be created on the two EC2 instances"
  default     = "ubuntu"
}

# ami-0f7d1f63870577e29 for Amazon Linux 2023
variable "ami_id" {
  type        = string
  description = "Amazon Machine Image identification"
  default     = "ami-08af887b5731562d3" # Ubuntu Server 22.04 LTS AMI
  # default     = "ami-0cc56294a584ac234" # Ubuntu Server 18.04 LTS AMI
}
