data "aws_iam_policy_document" "website-bucket-read" {
  "statement" {
    sid = "PublicRead"
    effect = "Allow"
    actions = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website-ttys0net.arn}/*"]
    principals {
      identifiers = ["*"]
      type = "AWS"
    }
  }
}
