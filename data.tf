#--------------------------------------------------------------
# Data Source
#--------------------------------------------------------------

data "aws_caller_identity" "current" {
}

data "aws_region" "current" {}

data "aws_route53_zone" "domain" {
  count = var.enabled ? 1 : 0

  name = "${var.route53_domain}."
}