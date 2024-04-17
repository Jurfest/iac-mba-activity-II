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
  instance_type = var.instance_type
  key_name      = var.key_name # Key pair name, existent in AWS account

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
      user        = var.username
      private_key = file("../../../../AWS/${var.key_name}.pem")
      host        = self.public_ip
      timeout     = "1m"
    }
  }
}

# Create EC2 instance to serve as a target server
resource "aws_instance" "managed_node" {
  ami           = "ami-0f7d1f63870577e29" # Amazon Linux 2023 AMI
  instance_type = var.instance_type
  key_name      = var.key_name # Key pair name, existent in AWS account

  tags = {
    Name = "ManagedNode"
  }

  vpc_security_group_ids = [aws_security_group.instance_sg.id]

  # Configure SSH authentication during provisioning
  # provisioner "remote-exec" {
  #   inline = [
  #     # Add the SSH public key of the control node to authorized_keys
  #     "echo '${aws_instance.control_node.key_name}' >> ~/.ssh/authorized_keys",
  #   ]

  #   connection {
  #     type        = "ssh"
  #     user        = var.username
  #     private_key = file("../../../../AWS/${var.key_name}.pem")
  #     host        = self.public_ip
  #     timeout     = "1m"
  #   }
  # }
}