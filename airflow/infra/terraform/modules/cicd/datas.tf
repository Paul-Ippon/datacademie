data "aws_s3_bucket" "airflow_bucket" {
  bucket = var.datacademie_bucket
}