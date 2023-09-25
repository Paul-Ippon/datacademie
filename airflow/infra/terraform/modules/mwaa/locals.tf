data "aws_caller_identity" "current" {}

locals {
  account_id  = data.aws_caller_identity.current.account_id
  region      = "us-east-1"

  webserver_access_mode = "PUBLIC_ONLY" // "PRIVATE_ONLY"

  mwaa_environment_class = "mw1.medium"
  mwaa_airflow_version   = "2.4.3"
}