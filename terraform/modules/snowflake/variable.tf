variable "environment" {}
variable "project" {}
variable "account_id" {}


locals {
  statement_timeout_in_seconds = {
    default = 3600
  }
  auto_suspend_in_seconds = {
    default = 60
  }
  data_retention_time_in_days = {
    default = 1
    sandbox = 1
  }

  snowflake_role = {
    sysadmin      = "SYSADMIN"
    securityadmin = "SECURITYADMIN"
    datadog       = "DATADOG"
    dbt           = "DBT"
    terraform     = "TERRAFORM" // WebUIから作成
  }
}
