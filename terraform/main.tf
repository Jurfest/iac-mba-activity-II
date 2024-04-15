# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.45"
#     }
#   }
# }

# provider "aws" {
#   region = "sa-east-1"
# }

# # Create security group
# resource "aws_security_group" "instance_sg" {
#   name        = "instance-sg"
#   description = "Security group for EC2 instance"

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# # Create EC2 instance to serve as the Ansible control server (i.e., control machine or control node)
# resource "aws_instance" "control_node" {
#   ami           = "ami-0f7d1f63870577e29" # Amazon Linux 2023 AMI
#   instance_type = "t2.micro"
#   key_name      = "mba-key-pair" # Key pair name, existent in AWS account

#   tags = {
#     Name = "ControlNode"
#   }

#   vpc_security_group_ids = [aws_security_group.instance_sg.id]

#   # Install Ansible and configure SSH authentication during provisioning
#   provisioner "remote-exec" {
#     inline = [
#       "sudo yum update -y",
#       "sudo yum install -y ansible",
#     ]

#     connection {
#       type        = "ssh"
#       user        = "ec2-user"
#       private_key = file("../../../../AWS/mba-key-pair.pem")
#       host        = self.public_ip
#       timeout     = "1m"
#     }
#   }
# }

# # Create EC2 instance to serve as a target server (i.e., target machine or target node, etc.)
# resource "aws_instance" "managed_node" {
#   ami           = "ami-0f7d1f63870577e29" # Amazon Linux 2023 AMI
#   instance_type = "t2.micro"
#   key_name      = "mba-key-pair" # Key pair name, existent in AWS account

#   tags = {
#     Name = "ManagedNode"
#   }

#   vpc_security_group_ids = [aws_security_group.instance_sg.id]
# }

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.41"
    }
  }
}

provider "aws" {
  region = "sa-east-1"
}

# Create security group
resource "aws_security_group" "instance_sg" {
  name        = "instance-sg"
  description = "Security group for EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 instance to serve as the Ansible control server
resource "aws_instance" "control_node" {
  ami           = "ami-0f7d1f63870577e29" # Amazon Linux 2023 AMI
  instance_type = "t2.micro"
  key_name      = "mba-key-pair" # Key pair name, existent in AWS account

  tags = {
    Name = "ControlNode"
  }

  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  # Install Ansible during provisioning
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y ansible",
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("../../../../AWS/mba-key-pair.pem")
      host        = self.public_ip
      timeout     = "1m"
    }
  }
}

# Create EC2 instance to serve as a target server
resource "aws_instance" "managed_node" {
  ami           = "ami-0f7d1f63870577e29" # Amazon Linux 2023 AMI
  instance_type = "t2.micro"
  key_name      = "mba-key-pair" # Key pair name, existent in AWS account

  tags = {
    Name = "ManagedNode"
  }

  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  # Configure SSH authentication during provisioning
  provisioner "remote-exec" {
    inline = [
      # Add the SSH public key of the control node to authorized_keys
      "echo '${aws_instance.control_node.key_name}' >> ~/.ssh/authorized_keys",
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("../../../../AWS/mba-key-pair.pem")
      host        = self.public_ip
      timeout     = "1m"
    }
  }
}

# Output public IP addresses
output "control_node_public_ip" {
  value = aws_instance.control_node.public_ip
}

output "managed_node_public_ip" {
  value = aws_instance.managed_node.public_ip
}
