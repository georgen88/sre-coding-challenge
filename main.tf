provider "aws" {
  region = var.region
}

terraform {
  # backend "s3" {
  #   bucket = "my-terraform-state-demo"
  #   key    = "terraform.tfstate"
  #   region = "us-east-1"
  # }
}

locals {
  tags = {
    Name = var.usage
    Automation  = "Terraform"
    Owner  = "Jorge Nava"
         }
  }