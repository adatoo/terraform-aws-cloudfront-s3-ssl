resource "aws_acm_certificate" "default" {
  provider          = aws.us-east-1 # US-EAST-1 region
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_acm_certificate_validation" "default" {
  provider                = aws.us-east-1 # US-EAST-1 region
  certificate_arn         = aws_acm_certificate.default.arn
  validation_record_fqdns = [aws_route53_record.validation.fqdn]
}
