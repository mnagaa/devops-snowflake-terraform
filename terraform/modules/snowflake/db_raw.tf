# Database for raw-data
resource "snowflake_database" "raw" {
  provider                    = snowflake.sys_admin
  name                        = upper("${var.environment}_raw_db")
  comment                     = "${var.environment} database created by terraform."
  data_retention_time_in_days = local.data_retention_time_in_days.default
}

// raw-db-ro
resource "snowflake_role" "raw-db-ro" {
  provider = snowflake.security_admin
  name     = upper("${var.environment}_raw_db_ro")
  comment  = "A role for database access with readonly."
}

// raw-db-rw
resource "snowflake_role" "raw-db-rw" {
  provider = snowflake.security_admin
  name     = upper("${var.environment}_raw_db_rw")
  comment  = "A role for database access with read and write."
}

// rwに対して、dbのro権限を付与する
resource "snowflake_role_grants" "raw-db-ro-to-rw" {
  provider  = snowflake.security_admin
  role_name = snowflake_role.raw-db-ro.name
  roles     = [snowflake_role.raw-db-rw.name]

  depends_on = [snowflake_role.raw-db-ro, snowflake_role.raw-db-rw]
}

// database access control: read only
// https://docs.snowflake.com/en/user-guide/security-access-control-configure.html#creating-custom-read-only-roles
resource "snowflake_database_grant" "raw-db" {
  provider               = snowflake.security_admin
  enable_multiple_grants = true
  database_name          = snowflake_database.raw.name
  for_each               = toset(["USAGE", "MONITOR"])
  privilege              = each.key
  roles                  = [snowflake_role.raw-db-ro.name]
}

resource "snowflake_schema_grant" "raw-schema" {
  provider               = snowflake.security_admin
  enable_multiple_grants = true
  database_name          = snowflake_database.raw.name
  for_each               = toset(["USAGE", "MONITOR"])
  privilege              = each.key
  roles                  = [snowflake_role.raw-db-ro.name]
  on_future              = true
}

resource "snowflake_table_grant" "raw-table" {
  provider               = snowflake.security_admin
  database_name          = snowflake_database.raw.name
  enable_multiple_grants = true
  for_each               = toset(["SELECT", "REFERENCES"])
  privilege              = each.key
  roles                  = [snowflake_role.raw-db-ro.name]
  on_future              = true
}

resource "snowflake_external_table_grant" "raw-external-table-select" {
  provider               = snowflake.security_admin
  database_name          = snowflake_database.raw.name
  enable_multiple_grants = true
  for_each               = toset(["SELECT"])
  privilege              = each.key
  roles                  = [snowflake_role.raw-db-ro.name]
  on_future              = true
}

resource "snowflake_view_grant" "raw-view-select" {
  provider               = snowflake.security_admin
  database_name          = snowflake_database.raw.name
  enable_multiple_grants = true
  for_each               = toset(["SELECT", "REFERENCES"])
  privilege              = each.key
  roles                  = [snowflake_role.raw-db-ro.name]
  on_future              = true
}

// database access control: read write
// see: https://docs.snowflake.com/ja/user-guide/security-access-control-privileges.html#database-privileges
resource "snowflake_database_grant" "raw-db-rw" {
  provider               = snowflake.security_admin
  enable_multiple_grants = true
  database_name          = snowflake_database.raw.name
  for_each               = toset(["MODIFY", "CREATE SCHEMA"])
  privilege              = each.key
  roles                  = [snowflake_role.raw-db-rw.name]
}

// schema privileges
// https://docs.snowflake.com/ja/user-guide/security-access-control-privileges.html#schema-privileges
// NOTE: 'ALL' can not be assigned as privilege.
resource "snowflake_schema_grant" "raw-db-rw" {
  provider               = snowflake.security_admin
  database_name          = snowflake_database.raw.name
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
  roles     = [snowflake_role.raw-db-rw.name]
  on_future = true
}

// table privileges
// https://docs.snowflake.com/en/user-guide/security-access-control-privileges.html#table-privileges
resource "snowflake_table_grant" "raw-db-rw-table" {
  provider               = snowflake.security_admin
  database_name          = snowflake_database.raw.name
  enable_multiple_grants = true
  for_each               = toset(["INSERT", "UPDATE", "TRUNCATE", "DELETE", "REFERENCES"])
  privilege              = each.key
  roles                  = [snowflake_role.raw-db-rw.name]
  on_future              = true
}
