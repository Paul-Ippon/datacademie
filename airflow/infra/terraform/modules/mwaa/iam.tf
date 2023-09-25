
resource "aws_iam_role" "mwaa_iam_role" {
  name = "${var.mwaa_environment_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "mwaa"
        Principal = {
          Service = [
            "airflow-env.amazonaws.com",
            "airflow.amazonaws.com"
          ]
        }
      },
    ]
  })

  tags = merge(var.tags, {
    Name = var.mwaa_environment_name
  })
}

data "aws_iam_policy_document" "iam_policy_document" {

  statement {
    sid = ""
    effect = "Allow"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = [
      "arn:aws:secretsmanager:${local.region}:${local.account_id}:secret:airflow/connections/*",
      "arn:aws:secretsmanager:${local.region}:${local.account_id}:secret:airflow/variables/*"
    ]
  }

  statement {
    actions = ["lambda:InvokeFunction"]
    resources = ["*"]
  }

  statement {
    actions = ["s3:*"]
    resources = ["arn:aws:s3:::datacademie*"]
  }

  statement {
    sid = ""
    effect = "Allow"
    actions = [
      "secretsmanager:ListSecrets"
    ]
    resources = [ "*" ]
  }

  statement {
    sid       = ""
    actions   = ["airflow:PublishMetrics"]
    effect    = "Allow"
    resources = ["arn:aws:airflow:${local.region}:${local.account_id}:environment/${var.mwaa_environment_name}"]
  }

  statement {
    sid     = ""
    actions = ["s3:ListAllMyBuckets"]
    effect  = "Allow"
    resources = [
      aws_s3_bucket.mwaa.arn,
      "${aws_s3_bucket.mwaa.arn}/*"
    ]
  }

  statement {
    sid = ""
    actions = [
      "s3:GetObject*",
      "s3:GetBucket*",
      "s3:List*"
    ]
    effect = "Allow"
    resources = [
      aws_s3_bucket.mwaa.arn,
      "${aws_s3_bucket.mwaa.arn}/*"
    ]
  }

  statement {
    sid       = ""
    actions   = ["logs:DescribeLogGroups"]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    sid = ""
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:GetLogRecord",
      "logs:GetLogGroupFields",
      "logs:GetQueryResults",
      "logs:DescribeLogGroups"
    ]
    effect    = "Allow"
    resources = ["arn:aws:logs:${local.region}:${local.account_id}:log-group:airflow-${var.mwaa_environment_name}*"]
  }

  statement {
    sid       = ""
    actions   = ["cloudwatch:PutMetricData"]
    effect    = "Allow"
    resources = ["*"]
  }

  statement {
    sid = ""
    actions = [
      "sqs:ChangeMessageVisibility",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage",
      "sqs:SendMessage"
    ]
    effect    = "Allow"
    resources = ["arn:aws:sqs:${local.region}:*:airflow-celery-*"]
  }

  statement {
    sid = ""
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
      "kms:Encrypt"
    ]
    effect        = "Allow"
    not_resources = ["arn:aws:kms:*:${local.account_id}:key/*"]
    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values = [
        "sqs.${local.region}.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_policy" "iam_policy" {
  name   = "${var.mwaa_environment_name}-policy"
  policy = data.aws_iam_policy_document.iam_policy_document.json
}

resource "aws_iam_role_policy_attachment" "iam_role_policy_attachment" {
  role       = aws_iam_role.mwaa_iam_role.name
  policy_arn = aws_iam_policy.iam_policy.arn
}