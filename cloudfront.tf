resource "aws_cloudfront_distribution" "main" {
  count = var.enabled ? 1 : 0

  price_class = var.cloudfront_price_class

  aliases             = var.route53_enabled ? local.aliases : []
  is_ipv6_enabled     = var.cloudfront_is_ipv6_enabled
  comment             = length(var.cloudfront_comment) > 0 ? var.cloudfront_comment : "${var.environment} => ${var.name}"
  default_root_object = var.cloudfront_default_root_object

  web_acl_id = element(data.aws_waf_web_acl.waf.*.id, 0)

  enabled = true

  wait_for_deployment = var.wait_for_deployment

  logging_config {
    include_cookies = true
    bucket          = element(data.aws_s3_bucket.logging_bucket.*.bucket_domain_name, 0)
    prefix          = length(var.cloudfront_logging_config_prefix) > 0 ? var.cloudfront_logging_config_prefix : "cloudfront/${var.environment}/${var.name}"
  }

  default_cache_behavior {
    allowed_methods        = var.cloudfront_default_cache_behavior_allowed_methods
    cached_methods         = var.cloudfront_default_cache_behavior_cached_methods
    target_origin_id       = "S3-${var.name}-latest"
    viewer_protocol_policy = var.cloudfront_default_cache_behavior_viewer_protocol_policy
    compress               = var.cloudfront_default_cache_behavior_compress

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

  }

  # Maintenance Page
  origin {
    domain_name = element(data.aws_s3_bucket.maintenance_bucket.*.bucket_domain_name, 0)
    origin_id   = "S3-exzeo-maintenance-page"
    origin_path = var.cloudfront_maintenance_path
  }

  # Origin
  origin {
    domain_name = element(data.aws_s3_bucket.origin_bucket.*.bucket_domain_name, 0)
    origin_id   = "S3-${var.name}-latest"
    origin_path = var.cloudfront_origin_path
  }

  dynamic "custom_error_response" {
    for_each = var.cloudfront_custom_error_codes

    content {
      error_code            = custom_error_response.value
      error_caching_min_ttl = 300
      response_code         = 200
      response_page_path    = "/${var.cloudfront_default_root_object}"
    }
  }

  tags = merge(local.tags, {})

  viewer_certificate {
    acm_certificate_arn      = var.cloudfront_viewer_certificate_acm_certificate_arn
    minimum_protocol_version = var.cloudfront_viewer_certificate_minimum_protocol_version
    ssl_support_method       = "sni-only"
  }

  lifecycle {
    ignore_changes = []
  }
}

