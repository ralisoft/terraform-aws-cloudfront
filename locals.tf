#--------------------------------------------------------------
# Local Variables
#--------------------------------------------------------------
locals {
  tags = merge(
    var.tags,
    {
      "ManagedBy"   = data.aws_caller_identity.current.arn
      "Environment" = var.environment
    },
  )

  aliases = compact(concat(formatlist("%s.${var.route53_domain}", var.route53_subdomains), [var.route53_root_domain ? var.route53_domain : "", ]))
}
