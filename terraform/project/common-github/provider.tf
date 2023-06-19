terraform {
  required_version = "~> 1.3.0"

  backend "s3" {
    bucket         = "terraform-state-mnagaa"
    region         = "ap-northeast-1"
    key            = "common-github.tfstate"
    dynamodb_table = "mnagaa-terraform-state-lock"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      env     = var.environment
      project = var.project
      owner   = "terraform"
      tfstate = "common-github"
    }
  }
}
