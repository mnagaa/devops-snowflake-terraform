locals {
  snowflake_role = {
    accountadmin  = "ACCOUNTADMIN"
    sysadmin      = "SYSADMIN"
    securityadmin = "SECURITYADMIN"
    terraform     = "TERRAFORM" // WebUIから作成
  }
}

// 開発者用のロール
resource "snowflake_role" "developer" {
  provider = snowflake.security_admin
  name     = upper("developer")
  comment  = "A role for developer."
}

// accountadminロールを利用できるユーザーを指定
resource "snowflake_role_grants" "accountadmin" {
  provider               = snowflake.security_admin
  role_name              = local.snowflake_role.accountadmin
  enable_multiple_grants = true
  users = [
    snowflake_user.mnagaa2.name,
  ]
}

resource "snowflake_role_grants" "developer" {
  provider               = snowflake.security_admin
  role_name              = snowflake_role.developer.name
  enable_multiple_grants = true

  roles = [local.snowflake_role.sysadmin]
  // developerを付与するユーザを指定
  users = [
    snowflake_user.mnagaa2.name,
  ]
}

