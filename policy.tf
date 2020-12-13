data "aws_iam_policy_document" "s3_policy" {
  count = var.enabled ? 1 : 0

  statement {
    actions   = ["s3:GetObject"]
    resources = ["${data.aws_s3_bucket.origin_bucket[0].arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "policy" {
  count = var.enabled ? 1 : 0

  bucket = data.aws_s3_bucket.origin_bucket[0].id
  policy = data.aws_iam_policy_document[0].s3_policy.json
}