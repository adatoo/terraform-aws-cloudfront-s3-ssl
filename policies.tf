resource "aws_cloudfront_origin_access_identity" "default" {}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.default.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.default.iam_arn]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.default.arn]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.default.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "default" {
  depends_on = [aws_s3_bucket_public_access_block.default]
  bucket     = aws_s3_bucket.default.id
  policy     = data.aws_iam_policy_document.s3_policy.json
}
