terraform {
  required_version = "> 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "=5.36.0"
    }
  }
  backend "s3" {
    bucket         = "myterraformbc"
    key            = "file/aws_aplication"
    region         = "us-west-2"
    dynamodb_table = "myterraformdb"
  }
}

provider "aws" {
  region = "us-west-2"
}