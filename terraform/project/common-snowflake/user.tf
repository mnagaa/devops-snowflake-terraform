resource "snowflake_user" "mnagaa2" {
  provider     = snowflake.user_admin
  name         = "mnagaa2"
  default_role = snowflake_role.developer.name
  comment      = "Created by Terraform."
}
