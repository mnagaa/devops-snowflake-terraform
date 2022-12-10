resource "snowflake_user" "mnagaa" {
  provider     = snowflake.user_admin
  name         = "mnagaa"
  default_role = snowflake_role.developer.name
  comment      = "Created by Terraform."
}
