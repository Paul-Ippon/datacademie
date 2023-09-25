resource "aws_s3_bucket" "mwaa" {
  bucket = "${var.mwaa_environment_name}-bucket"
  tags   = var.tags
}

resource "aws_s3_bucket_acl" "mwaa" {
  bucket = aws_s3_bucket.mwaa.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "mwaa" {
  bucket = aws_s3_bucket.mwaa.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "mwaa" {
  bucket = aws_s3_bucket.mwaa.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.mwaa.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Upload plugins/requirements.txt
resource "aws_s3_object" "requirements" {
  bucket = aws_s3_bucket.mwaa.id
  key    = "requirements.txt"
  source = "${path.module}/configurations/requirements.txt"
  etag   = filemd5("${path.module}/configurations/requirements.txt")
}