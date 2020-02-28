# --------------------------------------------------------------
#  AWS
# --------------------------------------------------------------
variable "aws_region" {
  type = string

  default = "us-east-1"
}

# --------------------------------------------------------------
#  CloudFront
# --------------------------------------------------------------
variable "cloudfront_default_root_object" {
  type    = string
  default = "index.html"
}

variable "cloudfront_viewer_certificate_acm_certificate_arn" {
  type = string

  default = ""
}

variable "cloudfront_price_class" {
  type    = string

  default = "PriceClass_100"
}

variable "cloudfront_is_ipv6_enabled" {
  type    = bool
  default = false
}

variable "cloudfront_comment" {
  type    = string

  default = ""
}

variable "cloudfront_logging_config_prefix" {
  type    = string
  
  default = ""
}

variable "cloudfront_logging_bucket" {
  type    = string
}

variable "cloudfront_default_cache_behavior_allowed_methods" {
  type    = list
  default = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
}

variable "cloudfront_default_cache_behavior_cached_methods" {
  type    = list
  default = ["GET", "HEAD"]
}

variable "cloudfront_default_cache_behavior_compress" {
  type    = bool
  default = true
}

variable "cloudfront_default_cache_behavior_viewer_protocol_policy" {
  type    = string
  default = "redirect-to-https"
}

variable "cloudfront_viewer_certificate_minimum_protocol_version" {
  type    = string
  default = "TLSv1.1_2016"
}

variable "cloudfront_maintenance_bucket" {
  type    = string
}

variable "cloudfront_maintenance_prefix" {
  type = string
}

variable "cloudfront_custom_error_codes" {
  type    = list
  default = [400, 403, 404, 500]
}

variable "cloudfront_origin_bucket" {
  type = string
}

variable "cloudfront_origin_prefix" {
  type = string
}

# --------------------------------------------------------------
#  Route53
# --------------------------------------------------------------
variable "route53_enabled" {
  type = bool

  default = true
}

variable "route53_domain" {
  type = string
}

variable "route53_subdomains" {
  type = list
}

variable "route53_root_domain" {
  type    = bool
  default = false
}

# --------------------------------------------------------------
#  Misc
# --------------------------------------------------------------
variable "tags" {
  type = map

  default = {}
}

variable "environment" {
  type = string
}

variable "enabled" {
  type = bool

  default = true
}

variable "name" {
  type = string
}