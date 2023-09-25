output "s3_bucket_id" {
  value       = aws_s3_bucket.mwaa.id
  description = "ID of MWAA S3 bucket."
}

output "mwaa_environment_arn" {
  value       = aws_mwaa_environment.mwaa_environment.arn
  description = "ARN of the MWAA environment."
}

output "mwaa_role_arn" {
  value       = aws_iam_role.mwaa_iam_role.arn
  description = "ARN of the MWAA execution role."
}

output "mwaa_role_id" {
  value       = aws_iam_role.mwaa_iam_role.id
  description = "ID of the MWAA execution role."
}

output "mwaa_webserver_url" {
  value       = "https://${aws_mwaa_environment.mwaa_environment.webserver_url}"
  description = "The webserver URL of the MWAA environment."
}