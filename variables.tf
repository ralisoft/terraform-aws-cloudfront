##  AWS
variable "aws_region" {
  type = string

  default = "us-east-1"
}

variable "aws_account" {
  type = string
}

## Cloudfront
variable "cloudfront_price_class" {
  type = string

  default = "PriceClass_100"
}

variable "cloudfront_comment" {
  type = string

  default = ""
}

variable "cloudfront_is_ipv6_enabled" {
  type = bool

  default = false
}

variable "cloudfront_default_root_object" {
  type = string

  default = "index.html"
}

variable "cloudfront_logging_config" {
  type = map(any)

  default = {}
}

variable "cloudfront_restrictions" {
  type = map(any)

  default = {}
}

variable "cloudfront_custom_error_response" {
  type = map(any)

  default = {}
}

variable "cloudfront_buckets" {
  type = list(any)

  default = []
}

variable "cloudfront_viewer_certificate" {
  type = map(any)

  default = {}
}

variable "cloudfront_default_cache_behavior" {
  type = map(any)

  default = {}
}

variable "cloudfront_waf_acl_name" {
  type = string

  default = "CloudFrontWAFRules"
}

variable "cloudfront_lambda_function" {
  type = map(any)

  default = {}
}

variable "cloudfront_offline_name" {
  type = string

  default = ""
}

## Application
variable "application" {
  type = string
}

variable "service" {
  type = string
}

variable "environment" {
  type = string
}

## Route53
variable "route53_hosted_zone" {
  type = string
  default = ""
}

variable "route53_subdomains" {
  type = list(string)

  default = []
}

variable "route53_root_domain" {
  type = bool

  default = false
}

## Tags
variable "tags" {
  type = map(any)

  default = {}
}

variable "wait_for_deployment" {
  type = bool

  default = false
}