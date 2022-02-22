variable "region" {
  default = "us-east-1"
}

variable "usage" {
  default = "jorge-nava-challenge"
}

variable "ami" {
  default = "ami-09d95fab7fff3776c"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "cidr-open" {
  default = "0.0.0.0/0"
}

variable "cidr_block-vpc" {
  default = "10.0.0.0/16"
}

variable "cidr_block-subnet" {
  default = "10.0.1.0/24"
}
 