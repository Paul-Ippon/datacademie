################################################################################
# IAM
################################################################################

resource "aws_iam_role" "lambda_role" {
  name               = "${var.function_name}-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  count      = length(var.lambda_policies_arn)
  role       = aws_iam_role.lambda_role.name
  policy_arn = var.lambda_policies_arn[count.index]
}

resource "aws_iam_role_policy_attachment" "lambda_execution_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}


data "archive_file" "lambda_package" {
  type        = var.source_file_type
  source_file = var.source_file
  output_path = "${var.function_name}.zip"
}

resource "aws_lambda_function" "lambda_function" {
  function_name    = var.function_name
  filename         = data.archive_file.lambda_package.output_path
  source_code_hash = data.archive_file.lambda_package.output_base64sha256
  role             = aws_iam_role.lambda_role.arn
  runtime          = var.runtime
  handler          = var.handler
  timeout          = var.timeout

  tracing_config {
    mode = "Active"
  }

  tags = var.tags
}