resource "aws_s3_bucket" "terraform_state" {
  bucket = "skj-terraform"
  acl    = "private"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket" "web_logs" {
  bucket = "skj-website-logs"
  acl    = "log-delivery-write"

  lifecycle_rule {
    enabled = true

    expiration {
      days = "365"
    }
  }
}
