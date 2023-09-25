data "aws_iam_policy_document" "cicd_user_policy_document" {
  statement {
    sid     = ""
    actions = ["s3:ListBucket"]
    effect  = "Allow"
    resources = [
      data.aws_s3_bucket.airflow_bucket.arn,
    ]
  }

  statement {
    sid = ""
    actions = [
      "s3:*Object"
    ]
    effect = "Allow"
    resources = [
      "${data.aws_s3_bucket.airflow_bucket.arn}/*"
    ]
  }
}

resource "aws_iam_user" "cicd_user" {
  force_destroy = "true"

  name = "cicd_user_datacademie_airflow"

  path = "/"

  tags = var.tags
}

resource "aws_iam_user_policy" "cicd_user_policy" {
  name = "cicd-user-datacademie-airflow-policy"
  user = aws_iam_user.cicd_user.name

  policy = data.aws_iam_policy_document.cicd_user_policy_document.json
}

resource "aws_iam_access_key" "cicd_user_access" {
  user = aws_iam_user.cicd_user.name
}

resource "aws_secretsmanager_secret" "cicd_user_secret" {
  name = "cicd-user-datacademie-airflow"
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "cicd_user_secret_version" {
  secret_id = aws_secretsmanager_secret.cicd_user_secret.id
  secret_string = jsonencode({
    access_key_id     = aws_iam_access_key.cicd_user_access.id
    access_secret_key = aws_iam_access_key.cicd_user_access.secret
  })
}