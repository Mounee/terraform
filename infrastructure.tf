provider "aws" {
	profile = "default"
	region  = "eu-west-1"
}


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
