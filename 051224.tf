provider "aws" {
  region = "ap-south-1"  # Corrected to the region
}

resource "aws_vpc" "my_vpc" {
  cidr_block           = "20.0.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "VPC011124"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "20.0.0.0/25"
  availability_zone = "ap-south-1a"  # Availability zone in the correct region
}

resource "aws_security_group" "nvsec" {
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
    Name = "ultssec"
  }
}

resource "aws_instance" "ubuntu_instance" {
  ami           = "ami-0dee22c13ea7a9a67"  # Replace with the latest Ubuntu AMI ID
  instance_type = "t2.micro"
  key_name      = "ukeym"  # Replace with your key pair name

  vpc_security_group_ids = [aws_security_group.nvsec.id]
  subnet_id              = aws_subnet.my_subnet.id  # Correctly reference the subnet
   associate_public_ip_address = true  # Enable auto-assigned public IP
  tags = {
    Name = "UIN051224"
  }
}