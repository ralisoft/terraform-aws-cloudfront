#--------------------------------------------------------------
# CloudFront
#--------------------------------------------------------------

resource "aws_cloudfront_distribution" "main" {
  count = var.enabled ? 1 : 0

  price_class = "PriceClass_All"

  aliases             = var.route53_enabled ? local.aliases : []
  comment             = length(var.cloudfront_comment) > 0 ? var.cloudfront_comment : "${var.environment} => ${var.name}"
  default_root_object = "index.html"

  enabled = true

  wait_for_deployment = false

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]

    target_origin_id       = "S3-${var.name}-origin"

    min_ttl          = "0"
    default_ttl      = "300"
    max_ttl          = "1200"

    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  # Maintenance Page
  # dynamic "origin" {
  #   for_each = var.cloudfront_maintenance_enabled ? [1] : []
  #   content {
  #     domain_name = var.cloudfront_maintenance_bucket
  #     origin_id   = "S3-${var.name}-maintenance"
  #     origin_path = var.cloudfront_maintenance_prefix
  #   }
  # }

  # Origin
  origin {
    origin_id   = "S3-${var.name}-origin"
    domain_name = var.cloudfront_origin_bucket    

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.example.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.cloudfront_geo_restriction_type
      locations        = var.cloudfront_geo_restriction_locations
    }
  }  

  # dynamic "custom_error_response" {
  #   for_each = var.cloudfront_custom_error_codes

  #   content {
  #     error_code            = custom_error_response.value
  #     error_caching_min_ttl = 300
  #     response_code         = 200
  #     response_page_path    = "/${var.cloudfront_default_root_object}"
  #   }
  # }

  tags = merge(local.tags, {})

  viewer_certificate {
    acm_certificate_arn      = var.cloudfront_viewer_certificate_acm_certificate_arn
    ssl_support_method       = "sni-only"
  }

  lifecycle {
    ignore_changes = []
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Some comment"
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
