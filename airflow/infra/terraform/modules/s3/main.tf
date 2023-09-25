
/* --------------------------------------------------------------------------------
   ------------------------------ RAW DATA S3 BUCKET ------------------------------
   -------------------------------------------------------------------------------- */

resource "aws_s3_bucket" "raw_data_s3_bucket" {
  bucket = var.raw_data_bucket_name
  tags   = var.tags
}

resource "aws_s3_bucket_acl" "raw_data_s3_bucket" {
  bucket = aws_s3_bucket.raw_data_s3_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "raw_data_s3_bucket" {
  bucket = aws_s3_bucket.raw_data_s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "raw_data_s3_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.raw_data_s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

/* --------------------------------------------------------------------------------
   ------------------------- PROCESSED DATA S3 BUCKET -----------------------------
   -------------------------------------------------------------------------------- */

resource "aws_s3_bucket" "processed_data_s3_bucket" {
  bucket = var.processed_data_bucket_name
  tags   = var.tags
}


resource "aws_s3_bucket_acl" "processed_data_s3_bucket" {
  bucket = aws_s3_bucket.processed_data_s3_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "processed_data_s3_bucket" {
  bucket = aws_s3_bucket.processed_data_s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "processed_data_s3_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.processed_data_s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}