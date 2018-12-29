data "aws_iam_policy_document" "108minutes" {
  "statement" {
    sid    = "108minutesCloudFrontAccess"
    effect = "Allow"

    principals {
      identifiers = ["${aws_cloudfront_origin_access_identity.108minutes.iam_arn}"]
      type        = "AWS"
    }

    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::108minutes.net/*"]
  }
}

data "aws_iam_policy_document" "ttys0" {
  "statement" {
    sid    = "ttys0CloudFrontAccess"
    effect = "Allow"

    principals {
      identifiers = ["${aws_cloudfront_origin_access_identity.ttys0.iam_arn}"]
      type        = "AWS"
    }

    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::ttys0.net/*"]
  }
}
