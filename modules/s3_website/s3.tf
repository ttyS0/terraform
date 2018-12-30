resource "aws_s3_bucket" "website" {
  bucket = "${var.root_domain}"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  logging {
    target_bucket = "${var.log_bucket}"
    target_prefix = "${var.root_domain}.s3/"
  }
}

resource "aws_s3_bucket_policy" "website" {
  bucket = "${var.root_domain}"
  policy = "${data.aws_iam_policy_document.website.json}"
}

data "aws_iam_policy_document" "website" {
  "statement" {
    sid       = "PublicReadGetObject"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.root_domain}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}
