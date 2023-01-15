# schema: sandbox
resource "snowflake_schema" "app-sandbox" {
  provider            = snowflake.sys_admin
  database            = snowflake_database.app.name
  name                = upper("sandbox")
  comment             = "Sandbox schema is owned by developers."
  is_transient        = false
  is_managed          = false
  data_retention_days = local.data_retention_time_in_days.sandbox
}

resource "snowflake_schema_grant" "app-sandbox-ownership" {
  provider               = snowflake.security_admin
  enable_multiple_grants = true
  database_name          = snowflake_database.app.name
  schema_name            = snowflake_schema.app-sandbox.name
  privilege              = "OWNERSHIP"
  roles                  = [var.roles.developer]
}
