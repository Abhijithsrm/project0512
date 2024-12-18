provider "aws" {
  region = "ap-south-1"  # Correct region for your resources
}

# Data source to reference the existing VPC named 'vpcdec10'
data "aws_vpc" "vpcdec10" {
  filter {
    name   = "tag:Name"
    values = ["vpcdec10"]
  }
}

# Data source to reference the existing Subnet named 'subdec10'
data "aws_subnet" "subdec10" {
  filter {
    name   = "tag:Name"
    values = ["subdec10"]
  }
}

# Security group definition
resource "aws_security_group" "secgp" {
  vpc_id = data.aws_vpc.vpcdec10.id  # Use existing VPC

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
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sec12"
  }
}

# Ubuntu EC2 instance definition
resource "aws_instance" "ubuntu_instance" {
  ami           = "ami-053b12d3152c0cc71"  # Replace with the latest Ubuntu AMI ID
  instance_type = "t2.micro"
  key_name      = "ukeym"  # Replace with your key pair name

  vpc_security_group_ids = [aws_security_group.secgp.id]
  subnet_id              = data.aws_subnet.subdec10.id  # Use existing subnet
  associate_public_ip_address = true  # Enable auto-assigned public IP

  tags = {
    Name = "UDEC18"
  }
}

# Output the public IP of the instance
output "instance_public_ip" {
  value = aws_instance.ubuntu_instance.public_ip
}
