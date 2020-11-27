variable "sharedcredslocation" {
      default = "/Users/chall/.aws/credentials"
}

variable "region" {
      default = "eu-west-1"
}

variable "availability-zone1" {
      default = "eu-west-1a"
}

variable "availability-zone2" {
      default = "eu-west-1b"
}

variable "bucket" {
      default = "mounirchallouk"
}

variable "ami" {
      default = "ami-0aef57767f5404a3c"
}

variable "instance-type" {
      default = "t2.micro"
}

variable "key_name" {
      default     = "ssh-key"
}

variable "public_key" {
      default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCbSsj7eFIGgzweCrMHgkc4ZVrCskLb6pjcw9PR1bgW70rPW8PFCOxtT+ZwLqjT6hlBJSgHBLYgkJgLR/zdVcd/LuX0HmFxNw9fm03aR5SpXVI1uPirVxP2pihUnJkak68nJPGMSr3phqKoihm/Mog4F0ohutLYcHCb3oqXE0PlLY/jhdnYGW8XAYplG8PdQidNvX7MjYgoRYtIiVa3c0k59NZPWGzqLHCypq0RIuLtptpoilipJ5YzVFJMBQJseWL2BmQB6js3nAtAhhvpXuAL/2ZAHfqucZvszghHxMIx61qxXkQCASIq+/c/5bNfO00mCMa8Y/yVG5kQabPxgawV"
}

variable "private_key" {
      default = "keys/mounir.pem"
}