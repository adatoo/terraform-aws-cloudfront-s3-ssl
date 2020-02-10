resource "aws_s3_bucket" "default" {
  bucket        = var.domain_name
  acl           = "private"
  force_destroy = true

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "default" {
  bucket = aws_s3_bucket.default.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
