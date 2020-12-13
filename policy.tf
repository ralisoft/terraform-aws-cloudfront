data "aws_iam_policy_document" "s3_policy" {
  count = var.enabled ? 1 : 0

  statement {
    actions   = ["s3:GetObject"]
    resources = ["${element(data.aws_s3_bucket.origin_bucket.arn, 0)}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "policy" {
  count = var.enabled ? 1 : 0

  bucket = element(data.aws_s3_bucket.origin_bucket.id, 0)
  policy = data.aws_iam_policy_document.s3_policy.json
}