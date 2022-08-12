terraform {
  required_version = "> 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

variable "udacity_vpc_id" {
  default = "vpc-0b6b23e0716cf3b25"
}

data "aws_vpc" "udacity_vpc" {
  id = var.udacity_vpc_id
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "udacity_ec2_block1" {
  ami           = "ami-033c62bb44bb03bc9"
  count         = "4"
  instance_type = "t2.micro"
  subnet_id     = "subnet-0d5b874f3ddcc9e43"
  tags = {
    Purpose = "Udacity"
  }
}

resource "aws_instance" "udacity_ec2_block2" {
  ami           = "ami-033c62bb44bb03bc9"
  count         = "0" // update to zero to destroy instances
  instance_type = "m4.large"
  subnet_id     = "subnet-0d5b874f3ddcc9e43"
  tags = {
    Purpose = "Udacity"
  }
}