data "aws_iam_policy_document" "datacademie_airflow_raw_data_rw" {
  statement {
    sid     = ""
    actions = ["s3:ListBucket"]
    effect  = "Allow"
    resources = [
      data.aws_s3_bucket.raw_bucket.arn,
    ]
  }

  statement {
    sid = ""
    actions = [
      "s3:*Object"
    ]
    effect = "Allow"
    resources = [
      "${data.aws_s3_bucket.raw_bucket.arn}/${var.user}/*"
    ]
  }
}

resource "aws_iam_policy" "datacademie_airflow_raw_data_rw" {
  name   = "${var.user}-datacademie-airflow-raw-data-rw-policy"
  policy = data.aws_iam_policy_document.datacademie_airflow_raw_data_rw.json
}

data "aws_iam_policy_document" "datacademie_airflow_processed_data_rw" {
  statement {
    sid     = ""
    actions = ["s3:ListBucket"]
    effect  = "Allow"
    resources = [
      data.aws_s3_bucket.processed_bucket.arn,
    ]
  }

  statement {
    sid = ""
    actions = [
      "s3:*Object"
    ]
    effect = "Allow"
    resources = [
      "${data.aws_s3_bucket.processed_bucket.arn}/${var.user}/*"
    ]
  }
}

resource "aws_iam_policy" "datacademie_airflow_processed_data_rw" {
  name   = "${var.user}-datacademie-airflow-processed-data-rw-policy"
  policy = data.aws_iam_policy_document.datacademie_airflow_processed_data_rw.json
}

data "aws_iam_policy_document" "datacademie_airflow_processed_data_ro" {
  statement {
    sid     = ""
    actions = ["s3:ListBucket"]
    effect  = "Allow"
    resources = [
      data.aws_s3_bucket.processed_bucket.arn
    ]
  }

  statement {
    sid = ""
    actions = [
      "s3:GetObject"
    ]
    effect = "Allow"
    resources = [
      "${data.aws_s3_bucket.processed_bucket.arn}/${var.user}/*"
    ]
  }
}


resource "aws_iam_user" "snowflake_user" {
  force_destroy = "true"

  name = "${var.user}_snowflake_load"

  path = "/"

  tags = local.tags
}

resource "aws_iam_user_policy" "snowflake_user_policy" {
  name = "${var.user}-snowflake-load-policy"
  user = aws_iam_user.snowflake_user.name

  policy = data.aws_iam_policy_document.datacademie_airflow_processed_data_ro.json
}

resource "aws_iam_access_key" "snowflake_user_access" {
  user = aws_iam_user.snowflake_user.name
}