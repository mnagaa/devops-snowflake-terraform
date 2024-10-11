terraform {
  required_version = "~> 1.3.0"

  backend "s3" {
    bucket         = "terraform-state-mnagaa"
    region         = "ap-northeast-1"
    key            = "common-snowflake.tfstate"
    dynamodb_table = "mnagaa-terraform-state-lock"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.52.0"
    }
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.97"
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
      tfstate = "${var.environment}-${var.project}"
    }
  }
}

provider "snowflake" {
  role  = "SYSADMIN"
  alias = "sys_admin"
}

provider "snowflake" {
  role  = "SECURITYADMIN"
  alias = "security_admin"
}

provider "snowflake" {
  role  = "USERADMIN"
  alias = "user_admin"
}

provider "snowflake" {
  role  = "TERRAFORM"
  alias = "terraform"
}
