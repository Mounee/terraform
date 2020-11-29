variable "sharedcredslocation" {
      default = "/Users/USER/.aws/credentials"
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
      default     = "ssh-rsa PUBLICKEY"
}

variable "private_key" {
      default = "keys/mounir.pem"
}
