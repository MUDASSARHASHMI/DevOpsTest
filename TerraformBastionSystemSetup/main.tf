# Provider configuration for AWS (will work with Localstack)
provider "aws" {
  region                  = var.region
  access_key              = "test"    # localstack default
  secret_key              = "test"    # localstack default
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  s3_use_path_style          = true
  endpoints {
    ec2 = "http://localhost:4566"
  }
}

# vars
variable "region" {
  default = "us-east-1"
}

variable "vpc_id" {
  description = "Existing VPC ID"
  type        = string
}

variable "public_subnet_id" {
  description = "Existing public subnet ID"
  type        = string
}

variable "key_pair_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "bastion-key"
}

# SG for bastion host
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  # ssh anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 machine for Bastion Host
resource "aws_instance" "bastion" {
  ami                    = "ami-XXXXXXXXXXXXXXXXX"
  instance_type          = "t2.micro"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name               = var.key_pair_name

  associate_public_ip_address = true

  tags = {
    Name = "bastion-host"
  }
}


output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}