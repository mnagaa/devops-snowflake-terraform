# Database for app-data
resource "snowflake_database" "app" {
  provider                    = snowflake.sys_admin
  name                        = upper("${var.environment}_app_db")
  comment                     = "${var.environment} database created by terraform."
  data_retention_time_in_days = local.data_retention_time_in_days.default
}

// app-db-ro
resource "snowflake_role" "app-db-ro" {
  provider = snowflake.security_admin
  name     = upper("${var.environment}_app_db_ro")
  comment  = "A role for database access with readonly."
}

// app-db-rw
resource "snowflake_role" "app-db-rw" {
  provider = snowflake.security_admin
  name     = upper("${var.environment}_app_db_rw")
  comment  = "A role for database access with read and write."
}

// rwに対して、dbのro権限を付与する
resource "snowflake_role_grants" "app-db-ro-to-rw" {
  provider  = snowflake.security_admin
  role_name = snowflake_role.app-db-ro.name
  roles     = [snowflake_role.app-db-rw.name]

  depends_on = [snowflake_role.app-db-ro, snowflake_role.app-db-rw]
}

// database access control: read only
// https://docs.snowflake.com/en/user-guide/security-access-control-configure.html#creating-custom-read-only-roles
resource "snowflake_database_grant" "app-db" {
  provider               = snowflake.security_admin
  enable_multiple_grants = true
  database_name          = snowflake_database.app.name
  for_each               = toset(["USAGE", "MONITOR"])
  privilege              = each.key
  roles                  = [snowflake_role.app-db-ro.name]
}

resource "snowflake_schema_grant" "app-schema" {
  provider               = snowflake.security_admin
  enable_multiple_grants = true
  database_name          = snowflake_database.app.name
  for_each               = toset(["USAGE", "MONITOR"])
  privilege              = each.key
  roles                  = [snowflake_role.app-db-ro.name]
  on_future              = true
}

resource "snowflake_table_grant" "app-table" {
  provider               = snowflake.security_admin
  database_name          = snowflake_database.app.name
  enable_multiple_grants = true
  for_each               = toset(["SELECT", "REFERENCES"])
  privilege              = each.key
  roles                  = [snowflake_role.app-db-ro.name]
  on_future              = true
}

resource "snowflake_external_table_grant" "app-external-table-select" {
  provider               = snowflake.security_admin
  database_name          = snowflake_database.app.name
  enable_multiple_grants = true
  for_each               = toset(["SELECT"])
  privilege              = each.key
  roles                  = [snowflake_role.app-db-ro.name]
  on_future              = true
}

resource "snowflake_view_grant" "app-view-select" {
  provider               = snowflake.security_admin
  database_name          = snowflake_database.app.name
  enable_multiple_grants = true
  for_each               = toset(["SELECT", "REFERENCES"])
  privilege              = each.key
  roles                  = [snowflake_role.app-db-ro.name]
  on_future              = true
}

// database access control: read write
// see: https://docs.snowflake.com/ja/user-guide/security-access-control-privileges.html#database-privileges
resource "snowflake_database_grant" "app-db-rw" {
  provider               = snowflake.security_admin
  enable_multiple_grants = true
  database_name          = snowflake_database.app.name
  for_each               = toset(["MODIFY", "CREATE SCHEMA"])
  privilege              = each.key
  roles                  = [snowflake_role.app-db-rw.name]
}

// schema privileges
// https://docs.snowflake.com/ja/user-guide/security-access-control-privileges.html#schema-privileges
resource "snowflake_schema_grant" "app-db-rw" {
  provider               = snowflake.security_admin
  database_name          = snowflake_database.app.name
  enable_multiple_grants = true
  for_each = toset([
    "CREATE TABLE",
    "CREATE EXTERNAL TABLE",
    "CREATE VIEW",
    "CREATE MATERIALIZED VIEW",
    "CREATE MASKING POLICY",
    "CREATE STAGE",
    "CREATE FILE FORMAT",
    "CREATE PIPE"
  ])
  privilege = each.key
  roles     = [snowflake_role.app-db-rw.name]
  on_future = true
}

// table privileges
// https://docs.snowflake.com/en/user-guide/security-access-control-privileges.html#table-privileges
resource "snowflake_table_grant" "app-db-rw-table" {
  provider               = snowflake.security_admin
  database_name          = snowflake_database.app.name
  enable_multiple_grants = true
  for_each               = toset(["INSERT", "UPDATE", "TRUNCATE", "DELETE", "REFERENCES"])
  privilege              = each.key
  roles                  = [snowflake_role.app-db-rw.name]
  on_future              = true
}
