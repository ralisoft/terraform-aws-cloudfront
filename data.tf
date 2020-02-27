data "aws_caller_identity" "current" {
}

data "aws_region" "current" {
}

data "aws_route53_zone" "domain" {
  count = var.enabled ? 1 : 0

  name         = "${var.route53_domain}."
  private_zone = var.route53_private_zone
}

data "aws_s3_bucket" "maintenance_bucket" {
  count = var.enabled ? 1 : 0

  bucket = var.cloudfront_maintenance_bucket
}

data "aws_s3_bucket" "logging_bucket" {
  count = var.enabled ? 1 : 0

  bucket = var.cloudfront_logging_bucket
}

data "aws_s3_bucket" "origin_bucket" {
  count = var.enabled ? 1 : 0

  bucket = var.cloudfront_origin_bucket
}

data "aws_waf_web_acl" "waf" {
  count = var.enabled && var.cloudfront_waf_enabled && var.cloudfront_waf_acl_name != ""  ? 1 : 0

  name = var.cloudfront_waf_acl_name
}
