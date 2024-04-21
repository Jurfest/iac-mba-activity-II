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
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name # Key pair name, existent in AWS account

  tags = {
    Name = "ControlNode"
  }

  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  # Install Ansible during provisioning
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y", # Update package lists
      "sudo apt-get install -y software-properties-common", # Install software-properties-common for managing repositories
      "sudo apt-add-repository --yes --update ppa:ansible/ansible", # Add Ansible PPA repository
      "sudo apt-get install -y ansible" # Install Ansible
    ]
    # Alternative commands to install ansible on Amazon Linux 2023
    # "sudo yum update -y",
    # "sudo yum install -y ansible",

    connection {
      type        = "ssh"
      user        = var.username
      private_key = file("../../../../AWS/${var.key_name}.pem")
      host        = self.public_ip
      timeout     = "1m"
    }
  }
}

# Create EC2 instance for the managed application node
resource "aws_instance" "managed_app_node" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name # Key pair name, existing in AWS account

  tags = {
    Name = "ManagedAppNode"
  }

  vpc_security_group_ids = [aws_security_group.instance_sg.id]
}

# Create EC2 instance for the managed database node
resource "aws_instance" "managed_db_node" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name # Key pair name, existing in AWS account

  tags = {
    Name = "ManagedDBNode"
  }

  vpc_security_group_ids = [aws_security_group.instance_sg.id]
}
