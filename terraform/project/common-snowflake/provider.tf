terraform {
  required_version = "~> 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.45.0"
    }
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.52"
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
