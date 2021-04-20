resource "aws_route53_record" "www" {
  count = length(local.route53_subdomains)

  zone_id = data.aws_route53_zone.main.zone_id
  name    = element(local.route53_subdomains, count.index)
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.main.domain_name
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
    evaluate_target_health = true
  }
}