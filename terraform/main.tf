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
    # Alternative commands to install ansible on Ubuntu (18.04 or later)
    # # python3 & pip are installed
    # "sudo apt update -y",
    # "sudo apt install python3-pip",

    # # install ansible
    # "sudo pip3 install ansible --upgrade"
    # # or try:  pip3 install ansible --upgrade --user

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
  ami           = "ami-0f7d1f63870577e29" # Amazon Linux 2023 AMI
  instance_type = var.instance_type
  key_name      = var.key_name # Key pair name, existing in AWS account

  tags = {
    Name = "ManagedAppNode"
  }

  vpc_security_group_ids = [aws_security_group.instance_sg.id]
}

# Create EC2 instance for the managed database node
resource "aws_instance" "managed_db_node" {
  ami           = "ami-0f7d1f63870577e29" # Amazon Linux 2023 AMI
  instance_type = var.instance_type
  key_name      = var.key_name # Key pair name, existing in AWS account

  tags = {
    Name = "ManagedDBNode"
  }

  vpc_security_group_ids = [aws_security_group.instance_sg.id]
}