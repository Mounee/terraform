#
#Bestand gemaakt door Mounir Challouk
#

provider "aws" {
	profile = "default"
	region  = "eu-west-1"
}

#Private bucket aanmaken
resource "aws_s3_bucket" "b" {
  	bucket = "mounirchallouk"
  	acl    = "private"

  	tags = {
    	Name        = "mounirchallouk"
    	Environment = "Dev"
  	}
}

#image.png uploaden naar aangemaakte bucket (public)
resource "aws_s3_bucket_object" "object" {
  	bucket = aws_s3_bucket.b.id
  	key    = "image.png"
  	source = "bucket/image.png"
	acl = "public-read"
}

#EC2 instance aanmaken
resource "aws_security_group" "instance" {
	name = "terraform-webserver"
	
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

resource "aws_instance" "example" {
	ami           = "ami-0aef57767f5404a3c"
	instance_type = "t2.micro"
	vpc_security_group_ids = [aws_security_group.instance.id]
	
    user_data = <<-EOF
				#!/bin/bash
				sudo su
				apt update
				apt-get install apache2 -y
				EOF  
				
	tags = {
		Name = "webserver1"
	}
}
