locals {
  s3_origin_id = "default-origin"
}

resource "aws_cloudfront_distribution" "default" {
  depends_on          = [aws_acm_certificate_validation.default]
  enabled             = true
  aliases             = [var.domain_name]
  default_root_object = "index.html"

  origin {
    origin_id   = local.s3_origin_id
    domain_name = aws_s3_bucket.default.bucket_regional_domain_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 300
    max_ttl                = 3600
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  # Distributes content to US and Europe
  price_class = "PriceClass_100"

  # Restricts who is able to access this content
  restrictions {
    geo_restriction {
      # type of restriction, blacklist, whitelist or none
      restriction_type = "none"
    }
  }

  # SSL certificate for the service.
  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.default.arn
    minimum_protocol_version       = "TLSv1.2_2018"
    ssl_support_method             = "sni-only"
    cloudfront_default_certificate = false
  }

  tags = var.tags
}
