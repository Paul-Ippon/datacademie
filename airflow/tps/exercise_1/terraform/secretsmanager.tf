resource "aws_secretsmanager_secret" "snowflake_user_secret" {
  name = "airflow/connections/aws/${aws_iam_user.snowflake_user.name}"
  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "snowflake_user_secret_version" {
  secret_id = aws_secretsmanager_secret.snowflake_user_secret.id
  secret_string = jsonencode({
    conn_id           = "aws_conn_for_${aws_iam_user.snowflake_user.name}",
    conn_type         = "aws",

    login     = aws_iam_access_key.snowflake_user_access.id
    password  = aws_iam_access_key.snowflake_user_access.secret

    extra={
      "region_name": "us-east-1",
    },
  })
}

resource "aws_secretsmanager_secret" "snowflake_connection" {
  name = "airflow/connections/snowflake/${var.user}"
  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "snowflake_connection_secret_version" {
  secret_id = aws_secretsmanager_secret.snowflake_connection.id
  secret_string = jsonencode({
    conn_type = "snowflake",
    login: var.snowflake_user,
    password: var.snowflake_password,
    schema: "SOURCE",
    extra: {
      account: "IPPONPARTNER",
      database: "DB_DATACADEMIE_${upper(var.user)}",
      region: "eu-west-1",
      warehouse: "WH_DATACADEMIE_${upper(var.user)}"
    }
  })
}

