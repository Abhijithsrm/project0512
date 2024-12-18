provider "aws" {
  region = "ap-south-1"  # Corrected to the region
}

# Data source to reference the existing VPC by name (dc1024)
data "aws_vpc" "dc1024" {
  filter {
    name   = "tag:Name"
    values = ["dc1024"]
  }
}

# Subnet within the existing VPC
resource "aws_subnet" "svpcdec10" {
  vpc_id     = data.aws_vpc.dc1024.id
  cidr_block = "10.0.0.0/25"  # Subnet within the VPC
  availability_zone = "ap-south-1"  # Replace with your preferred AZ
  tags = {
    Name = "svpcdec10"
  }
}

resource "aws_security_group" "secgp" {
  vpc_id = aws_vpc.my_vpc.id

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

resource "aws_instance" "ubuntu_instance" {
  ami           = "ami-053b12d3152c0cc71"  # Replace with the latest Ubuntu AMI ID
  instance_type = "t2.micro"
  key_name      = "ukeym"  # Replace with your key pair name

  vpc_security_group_ids = [aws_security_group.secgp.id]
  subnet_id              = aws_subnet.my_subnet.id  # Correctly reference the subnet
   associate_public_ip_address = true  # Enable auto-assigned public IP
  tags = {
    Name = "UDEC18"
  }
}

