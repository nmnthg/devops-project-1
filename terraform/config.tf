terraform {
  required_version = ">= 1.12.2"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "nmnthg-terraform-states"
    key    = "devops-project-1/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
  } 
}

provider "aws" {
  region = "us-east-1"
}
