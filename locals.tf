#--------------------------------------------------------------
# locals - common variables
#--------------------------------------------------------------
locals {
  tags = merge(
    var.tags,
    {
      "Environment" = var.environment
      "Service"     = var.service
      "Application" = var.application
    },
  )

  route53_subdomains = compact(concat(formatlist("%s.${var.route53_hosted_zone}", var.route53_subdomains), [var.route53_root_domain ? var.route53_hosted_zone : "", ]))

  cloudfront_lambda_function_arn = "arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:${try(var.cloudfront_lambda_function.name, "")}:${try(var.cloudfront_lambda_function.version, "")}"
}