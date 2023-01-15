# schema: sandbox
resource "snowflake_schema" "mart-sandbox" {
  provider            = snowflake.sys_admin
  database            = snowflake_database.mart.name
  name                = upper("sandbox")
  comment             = "Sandbox schema is owned by developers."
  is_transient        = false
  is_managed          = false
  data_retention_days = local.data_retention_time_in_days.sandbox
}

resource "snowflake_schema_grant" "mart-sandbox-ownership" {
  provider               = snowflake.security_admin
  enable_multiple_grants = true
  database_name          = snowflake_database.mart.name
  schema_name            = snowflake_schema.mart-sandbox.name
  privilege              = "OWNERSHIP"
  roles                  = [local.snowflake_role.developer]
}
