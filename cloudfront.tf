#--------------------------------------------------------------
# CloudFront
#--------------------------------------------------------------

resource "aws_cloudfront_distribution" "main" {
  count = var.enabled ? 1 : 0

  price_class = var.cloudfront_price_class

  aliases             = var.route53_enabled ? local.aliases : []
  is_ipv6_enabled     = var.cloudfront_is_ipv6_enabled
  comment             = length(var.cloudfront_comment) > 0 ? var.cloudfront_comment : "${var.environment} => ${var.name}"
  default_root_object = var.cloudfront_default_root_object

  enabled = true

  wait_for_deployment = false

  default_cache_behavior {
    allowed_methods        = var.cloudfront_default_cache_behavior_allowed_methods
    cached_methods         = var.cloudfront_default_cache_behavior_cached_methods
    target_origin_id       = "S3-${var.name}-origin"
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
    origin_id   = "S3-${var.name}-maintenance"
    origin_path = var.cloudfront_maintenance_prefix
  }

  # Origin
  origin {
    domain_name = element(data.aws_s3_bucket.origin_bucket.*.bucket_domain_name, 0)
    origin_id   = "S3-${var.name}-origin"
    origin_path = var.cloudfront_origin_prefix
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

output "cloudfront_id" {
  value = var.enabled ? aws_cloudfront_distribution.main[0].id : ""
}

output "cloudfront_arn" {
  value = var.enabled ? aws_cloudfront_distribution.main[0].arn : ""
}

output "cloudfront_domain_name" {
  value = var.enabled ? aws_cloudfront_distribution.main[0].domain_name : ""
}

output "cloudfront_hosted_zone_id" {
  value = var.enabled ? aws_cloudfront_distribution.main[0].hosted_zone_id : ""
}
