data "aws_s3_bucket" "raw_bucket" {
  bucket = local.raw_data_bucket_name
}

data "aws_s3_bucket" "processed_bucket" {
  bucket = local.processed_data_bucket_name
}