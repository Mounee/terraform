#
#Bestand gemaakt door Mounir Challouk
#

provider "aws" {
	profile = "default"
	region  = var.region
}

#Private bucket aanmaken
resource "aws_s3_bucket" "bucket" {
  	bucket = var.bucket
  	acl    = "private"

  	tags = {
    	Name        = var.bucket
    	Environment = "Dev"
  	}
}

#image.png uploaden naar aangemaakte bucket (public)
resource "aws_s3_bucket_object" "object" {
  	bucket = aws_s3_bucket.bucket.id
  	key    = "image.png"
  	source = "bucket/image.png"
	acl = "public-read"
}

#VPC maken
resource "aws_vpc" "Mounir-VPC" {
		cidr_block= "10.0.0.0/16"
		instance_tenancy= "default"
		enable_dns_support= "true"
		enable_dns_hostnames= "true"
		enable_classiclink= "false"
	tags = {
		Name = "Mounir-VPC"
	}
}

# create public subnet1
resource "aws_subnet" "Mounir-PublicSubnet1" {
	vpc_id = aws_vpc.Mounir-VPC.id
	cidr_block = "10.0.1.0/24"
	map_public_ip_on_launch = "true"
	availability_zone = "eu-west-1a"
	tags = {
		Name = "Mounir-PublicSubnet1"
	}
}

# create public subnet2
resource "aws_subnet" "Mounir-PublicSubnet2" {
	vpc_id = aws_vpc.Mounir-VPC.id
	cidr_block = "10.0.2.0/24"
	map_public_ip_on_launch = "true"
	availability_zone = "eu-west-1b"
	tags = {
		Name = "Mounir-PublicSubnet2"
	}
}

# Create the Internet Gateway
resource "aws_internet_gateway" "Mounir-Gateway" {
 	vpc_id = aws_vpc.Mounir-VPC.id
 	tags = {
        Name = "Mounir-Gateway"
	}
}

# Routing table maken
resource "aws_route_table" "Mounir-rt-public"{
	vpc_id = aws_vpc.Mounir-VPC.id
	route{
		cidr_block= "0.0.0.0/0"
		gateway_id = aws_internet_gateway.Mounir-Gateway.id
	}
	tags = {
		Name = "Mounir-rt-public"
	}
}

# Routing table association
resource "aws_route_table_association" "Mounir-public-1" {
	subnet_id= aws_subnet.Mounir-PublicSubnet1.id
	route_table_id = aws_route_table.Mounir-rt-public.id
}
resource "aws_route_table_association" "Mounir-public-2" {
	subnet_id= aws_subnet.Mounir-PublicSubnet2.id
	route_table_id = aws_route_table.Mounir-rt-public.id
}

#AWS Security group aanmaken
resource "aws_security_group" "securityGroup" {
	vpc_id = aws_vpc.Mounir-VPC.id
	name = "terraform-webserver"

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

	ingress {
		from_port   = 443
		to_port     = 443
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

#SSH Key pair
resource "aws_key_pair" "custom-key" {
	key_name= var.key_name
	public_key= var.public_key
}

#EC2 instance aanmaken
resource "aws_instance" "example" {
	ami           = var.ami
	instance_type = var.instance-type
	vpc_security_group_ids = [aws_security_group.securityGroup.id]
	key_name = aws_key_pair.custom-key.key_name
	subnet_id = aws_subnet.Mounir-PublicSubnet1.id

    user_data = <<-EOF
				#!/bin/bash
				sudo su
				apt update
				apt-get install apache2 -y
				apt install php php-mysql libapache2-mod-php php-cli -y
				rm /var/www/html/index.html
				echo "<?php phpinfo(); ?>" > /var/www/html/index.php
				EOF
				
	tags = {
		Name = "webserver1"
	}
}

#Public IP output in CMD na apply
output "public_ip" {
	value = aws_instance.example.public_ip
}
