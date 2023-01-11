terraform {
  required_version = "~> 1.3.0"

  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.55"
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