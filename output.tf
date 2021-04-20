output "cloudfront_id" {
  value = aws_cloudfront_distribution.main.id
}

output "cloudfront_arn" {
  value = aws_cloudfront_distribution.main.arn
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.main.domain_name
}

output "cloudfront_hosted_zone_id" {
  value = aws_cloudfront_distribution.main.hosted_zone_id
}

output "cloudfront_origin_access_identity" {
  value = aws_cloudfront_origin_access_identity.origin_access_identity
}