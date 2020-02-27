#--------------------------------------------------------------
# locals - common variables
#--------------------------------------------------------------
locals {
  tags = merge(
    var.tags,
    {
      "ManagedBy"   = data.aws_caller_identity.current.arn
      "Environment" = var.environment
    },
  )
}

