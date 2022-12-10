module "snowflake" {
  source      = "../../../modules/snowflake"
  environment = var.environment
  project     = var.project
  account_id  = var.account_id
}
