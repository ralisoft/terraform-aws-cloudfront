data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_s3_bucket" "logging_bucket" {
  bucket = try(var.cloudfront_logging_config.bucket, "${var.aws_account}-logging-${var.aws_region}")
}

data "aws_waf_web_acl" "waf" {
  name = var.cloudfront_waf_acl_name
}

data "aws_route53_zone" "main" {
  name         = var.route53_hosted_zone
  private_zone = false
}