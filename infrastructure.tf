#
#Bestand gemaakt door Mounir Challouk
#

provider "aws" {
	profile = "default"
	region  = var.region
    shared_credentials_file = var.sharedcredslocation
}

#Private bucket aanmaken
resource "aws_s3_bucket" "bucket" {
  	bucket = var.bucket
  	acl    = "private"
	tags = {
    	Name = var.bucket
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
	availability_zone = var.availability-zone1
	tags = {
		Name = "Mounir-PublicSubnet1"
	}
}

# create public subnet2
resource "aws_subnet" "Mounir-PublicSubnet2" {
	vpc_id = aws_vpc.Mounir-VPC.id
	cidr_block = "10.0.2.0/24"
	map_public_ip_on_launch = "true"
	availability_zone = var.availability-zone2
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
	subnet_id	= aws_subnet.Mounir-PublicSubnet1.id
	route_table_id = aws_route_table.Mounir-rt-public.id
}
resource "aws_route_table_association" "Mounir-public-2" {
	subnet_id	= aws_subnet.Mounir-PublicSubnet2.id
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

#EC2 instances (2 in subnet 1, 1 in subnet 2) aanmaken
resource "aws_instance" "webservers1and2" {
	ami           = var.ami
	instance_type = var.instance-type
	vpc_security_group_ids = [aws_security_group.securityGroup.id]
	key_name = aws_key_pair.custom-key.key_name
	subnet_id = aws_subnet.Mounir-PublicSubnet1.id
	count = 2

	user_data = <<-EOF
					#!/bin/bash

					sudo su
					apt update
					apt-get install apache2 -y
					apt install php php-mysql libapache2-mod-php php-cli -y
					rm /var/www/html/index.html
					mv /home/ubuntu/index.php /var/www/html/
					sed -i "s@ENDPOINT@'${aws_apigatewayv2_api.apigw.api_endpoint}'@g" /var/www/html/index.php
					sed -i "s@BUCKET@${var.bucket}@g" /var/www/html/index.php
					sed -i "s@REGION@${var.region}@g" /var/www/html/index.php
				EOF

	tags = {
		Name = "webserver${(count.index)+1}"
	}

	provisioner "file" {
    	source      = "webpage/index.php"
    	destination = "/home/ubuntu/index.php"
		connection {
			user = "ubuntu"
			private_key = file(var.private_key)
			host = self.public_dns
		}
  	}
}

resource "aws_instance" "webserver3" {
	ami           = var.ami
	instance_type = var.instance-type
	vpc_security_group_ids = [aws_security_group.securityGroup.id]
	key_name = aws_key_pair.custom-key.key_name
	subnet_id = aws_subnet.Mounir-PublicSubnet2.id

	user_data = <<-EOF
					#!/bin/bash

					sudo su
					apt update
					apt-get install apache2 -y
					apt install php php-mysql libapache2-mod-php php-cli -y
					rm /var/www/html/index.html
					mv /home/ubuntu/index.php /var/www/html/
					sed -i "s@ENDPOINT@'${aws_apigatewayv2_api.apigw.api_endpoint}'@g" /var/www/html/index.php
					sed -i "s@BUCKET@${var.bucket}@g" /var/www/html/index.php
					sed -i "s@REGION@${var.region}@g" /var/www/html/index.php
				EOF

	tags = {
		Name = "webserver3"
	}

	provisioner "file" {
    	source      = "webpage/index.php"
    	destination = "/home/ubuntu/index.php"
		connection {
			user = "ubuntu"
			private_key = file(var.private_key)
			host = self.public_dns
		}
  	}

}


#Load Balancer
resource "aws_lb" "loadbalancer" {
  	name               	= "terraform-lb"
	load_balancer_type 	= "application"
  	internal           	= false
  	security_groups    	= [aws_security_group.securityGroup.id]
  	subnets            	= [aws_subnet.Mounir-PublicSubnet1.id, aws_subnet.Mounir-PublicSubnet2.id]
	ip_address_type 	= "ipv4"
}

#Load Balancer Listener
resource "aws_lb_listener" "lblistener" {
	load_balancer_arn 	= aws_lb.loadbalancer.arn
	port = 80
	protocol = "HTTP"
	default_action {
		type = "forward"
		target_group_arn = aws_lb_target_group.Mounir-lbtargetgroup.arn
	}
}

#Load Balancer Target Group
resource "aws_lb_target_group" "Mounir-lbtargetgroup" {
	health_check {
		interval = 10
		path = "/"
		protocol = "HTTP"
		timeout = 5
		healthy_threshold = 5
		unhealthy_threshold = 2
	}

  	name     	= "terraform-lb-targetgroup"
  	port     	= 80
  	protocol 	= "HTTP"
  	vpc_id   	= aws_vpc.Mounir-VPC.id
	target_type = "instance"
}

#Target Group registreren met EC2 instance 1 en 2
resource "aws_lb_target_group_attachment" "targetgroupattachment-ec1and2" {
	count = length(aws_instance.webservers1and2)
  	target_group_arn = aws_lb_target_group.Mounir-lbtargetgroup.arn
  	target_id        = aws_instance.webservers1and2[count.index].id
  	port             = 80
}

#Target Group registreren met EC2 instance 3
resource "aws_lb_target_group_attachment" "targetgroupattachment-ec3" {
  	target_group_arn = aws_lb_target_group.Mounir-lbtargetgroup.arn
  	target_id        = aws_instance.webserver3.id
  	port             = 80
}

#Python code klaarmaken voor upload naar Lambda functie
data "archive_file" "pythonfile" {
    type = "zip"

    source_file = "lambda/lambda_function-1.py"
    output_path = "lambda/lambda_function-1.zip"
}

#IAM Rol aanmaken voor Lambda functie
resource "aws_iam_role" "iam_for_lambda" {
    name = "iam_for_lambda"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

#Lambda functie
resource "aws_lambda_function" "lambda_function" {
    filename      = "lambda/lambda_function-1.zip"
    function_name = "terraform_lambda_function"
    role          = aws_iam_role.iam_for_lambda.arn
    handler       = "lambda_function-1.lambda_handler"
    runtime       = "python3.8"
}

#HTTP API Gateway
resource "aws_apigatewayv2_api" "apigw" {
    name          = "terraform-http-api"
    protocol_type = "HTTP"
    target = aws_lambda_function.lambda_function.arn
}

#Permission om functie te revoken
resource "aws_lambda_permission" "apigwperm" {
	action        = "lambda:InvokeFunction"
	function_name = aws_lambda_function.lambda_function.arn
	principal     = "apigateway.amazonaws.com"

	source_arn = "${aws_apigatewayv2_api.apigw.execution_arn}/*/*"
}

#output in CMD na apply
output "webserver1_public_ip" {
	value = aws_instance.webservers1and2[0].public_ip
}

output "webserver2_public_ip" {
	value = aws_instance.webservers1and2[1].public_ip
}

output "webserver3_public_ip" {
	value = aws_instance.webserver3.public_ip
}

output "loadbalancer_dns_name" {
	value = aws_lb.loadbalancer.dns_name
}

output "api_gateway_endpoint" {
    value = aws_apigatewayv2_api.apigw.api_endpoint
}