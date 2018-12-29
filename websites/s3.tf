resource "aws_s3_bucket" "108minutes" {
  bucket = "108minutes.net"
  acl    = "private"

  policy = "${data.aws_iam_policy_document.108minutes.json}"

  website {
    index_document = "index.html"
  }

  logging {
    target_bucket = "${aws_s3_bucket.logs.id}"
    target_prefix = "108minutes-s3/"
  }
}

resource "aws_s3_bucket" "ttys0" {
  bucket = "ttys0.net"
  acl    = "private"

  policy = "${data.aws_iam_policy_document.ttys0.json}"

  website {
    index_document = "index.html"
  }

  logging {
    target_bucket = "${aws_s3_bucket.logs.id}"
    target_prefix = "ttys0-s3/"
  }
}

resource "aws_s3_bucket" "logs" {
  bucket = "skj-website-logs"
  acl    = "log-delivery-write"

  lifecycle_rule {
    enabled = true

    expiration {
      days = "365"
    }
  }
}
