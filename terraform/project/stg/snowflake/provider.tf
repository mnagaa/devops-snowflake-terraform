terraform {
  required_version = "~> 1.3.0"

  backend "s3" {
    bucket         = "terraform-state-mnagaa"
    region         = "ap-northeast-1"
    key            = "stg-snowflake.tfstate"
    dynamodb_table = "mnagaa-terraform-state-lock"
  }

  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.97"
    }
  }
}
