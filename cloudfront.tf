resource "aws_cloudfront_distribution" "main" {
  price_class = var.cloudfront_price_class

  aliases             = try(local.route53_subdomains, [])
  is_ipv6_enabled     = var.cloudfront_is_ipv6_enabled
  comment             = length(var.cloudfront_comment) > 0 ? var.cloudfront_comment : "${var.environment} => ${var.service}"
  default_root_object = var.cloudfront_default_root_object
  enabled             = true
  wait_for_deployment = var.wait_for_deployment

  web_acl_id = data.aws_waf_web_acl.waf.id

  dynamic "logging_config" {
    for_each = try(var.cloudfront_logging_config.enabled, true) ? [1] : []

    content {
      include_cookies = try(var.cloudfront_logging_config.include_cookies, true)
      bucket          = data.aws_s3_bucket.logging_bucket.bucket_domain_name
      prefix          = try(var.cloudfront_logging_config.prefix, "cloudfront/${var.application}/${var.environment}/${var.service}")
    }
  }

  default_cache_behavior {
    allowed_methods        = split(",", try(var.cloudfront_default_cache_behavior.allowed_methods, "GET,HEAD,OPTIONS"))
    cached_methods         = split(",", try(var.cloudfront_default_cache_behavior.cached_methods, "GET,HEAD"))
    target_origin_id       = "S3-${var.service}"
    viewer_protocol_policy = try(var.cloudfront_default_cache_behavior.viewer_protocol_policy, "redirect-to-https")
    compress               = try(var.cloudfront_default_cache_behavior.compress, false)

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    dynamic "lambda_function_association" {
      for_each = try(var.cloudfront_lambda_function.enabled, true) ? [1] : []

      content {
        event_type = try(var.cloudfront_default_cache_behavior.lambda_function_association.event_type, "origin-response")
        include_body = try(var.cloudfront_default_cache_behavior.lambda_function_association.include_body, false)
        lambda_arn = try(var.cloudfront_default_cache_behavior.lambda_function_association.lambda_arn, local.cloudfront_lambda_function_arn)
      }
    }
  }

  # Origin Group
  origin_group {
    origin_id = "S3-${var.service}"

    failover_criteria {
      status_codes = [403, 500, 502, 503, 504]
    }

    dynamic "member" {
      for_each = var.cloudfront_buckets

      content {
        origin_id = "S3-${var.service}-${member.value.region}"
      }
    }
  }

  dynamic "origin_group" {
    for_each = var.cloudfront_offline_name != "" ? [1] : []

    content {
      origin_id = "S3-offline"

      failover_criteria {
        status_codes = [403, 500, 502, 503, 504]
      }

      dynamic "member" {
        for_each = var.cloudfront_buckets

        content {
          origin_id = "S3-offline-${member.value.region}"
        }
      }
    }
  }

  # Origin
  dynamic "origin" {
    for_each = var.cloudfront_buckets

    content {
      domain_name = origin.value.bucket_regional_domain_name
      origin_id   = "S3-${var.service}-${origin.value.region}"
      origin_path = "/${var.service}"

      s3_origin_config {
        origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
      }

      custom_header {
        name = "x-application-name"
        value = var.application
      }

      custom_header {
        name = "x-service-name"
        value = var.service
      }

      custom_header {
        name = "x-environment-name"
        value = var.environment
      }      
    }
  }

  dynamic "origin" {
    for_each = var.cloudfront_offline_name != "" ? var.cloudfront_buckets : []

    content {
      domain_name = origin.value.bucket_regional_domain_name
      origin_id   = "S3-offline-${origin.value.region}"
      origin_path = "/${var.cloudfront_offline_name}"

      s3_origin_config {
        origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
      }    
    }
  }

  dynamic "restrictions" {
    for_each = try(var.cloudfront_restrictions.enabled, true) ? [1] : []

    content {
      geo_restriction {
        restriction_type = try(var.cloudfront_restrictions.restriction_type, "whitelist")
        locations        = split(",", try(var.cloudfront_restrictions.locations, "US,CA,GB,IN"))
      }
    }
  }

  dynamic "custom_error_response" {
    for_each = split(",", try(var.cloudfront_custom_error_response.error_codes, "400,403,404,500"))

    content {
      error_code            = custom_error_response.value
      error_caching_min_ttl = try(var.cloudfront_custom_error_response.error_caching_min_ttl, 300)
      response_code         = try(var.cloudfront_custom_error_response.response_code, 200)
      response_page_path    = try(var.cloudfront_custom_error_response.response_page_path, "/${var.cloudfront_default_root_object}")
    }
  }

  tags = merge(local.tags, {})

  viewer_certificate {
    acm_certificate_arn      = try(aws_acm_certificate.main.arn, "cloudfront_default_certificate")
    minimum_protocol_version = try(var.cloudfront_viewer_certificate.minimum_protocol_version, "TLSv1.2_2018")
    ssl_support_method       = try(var.cloudfront_viewer_certificate.ssl_support_method, "sni-only")
  }

  lifecycle {
    ignore_changes = []
  }
}


resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  
}