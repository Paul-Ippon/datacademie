module "lambda_extraction" {
  source = "./module/lambda"

  function_name = "${var.user}-extraction-lambda"

  source_file = "${path.module}/lambda_code/lambda_function_extract.py"

  handler = "lambda_function_extract.lambda_handler"

  lambda_policies_arn = [
    aws_iam_policy.datacademie_airflow_raw_data_rw.arn
  ]

  tags = local.tags
}

module "lambda_transformation_stations_informations" {
  source = "./module/lambda"

  function_name = "${var.user}-transformation-stations-informations-lambda"

  source_file = "${path.module}/lambda_code/lambda_function_transform_stations_informations.py"

  handler = "lambda_function_transform_stations_informations.lambda_handler"

  lambda_policies_arn = [
    aws_iam_policy.datacademie_airflow_raw_data_rw.arn,
    aws_iam_policy.datacademie_airflow_processed_data_rw.arn
  ]

  tags = local.tags
}

module "lambda_transformation_stations_status" {
  source = "./module/lambda"

  function_name = "${var.user}-transformation-stations-status-lambda"

  source_file = "${path.module}/lambda_code/lambda_function_transform_stations_status.py"

  handler = "lambda_function_transform_stations_status.lambda_handler"

  lambda_policies_arn = [
    aws_iam_policy.datacademie_airflow_raw_data_rw.arn,
    aws_iam_policy.datacademie_airflow_processed_data_rw.arn
  ]

  tags = local.tags
}