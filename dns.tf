data "aws_route53_zone" "default" {
  name         = var.hosted_zone
  private_zone = false
}

resource "aws_route53_record" "validation" {
  zone_id = data.aws_route53_zone.default.zone_id
  name    = aws_acm_certificate.default.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.default.domain_validation_options.0.resource_record_type
  records = [aws_acm_certificate.default.domain_validation_options.0.resource_record_value]
  ttl     = 60
}

resource "aws_route53_record" "domain" {
  zone_id = data.aws_route53_zone.default.zone_id
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.default.domain_name
    zone_id                = aws_cloudfront_distribution.default.hosted_zone_id
    evaluate_target_health = false
  }
}
