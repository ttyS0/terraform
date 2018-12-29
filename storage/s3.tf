resource "aws_s3_bucket" "terraform_state" {
  bucket = "skj-terraform"
  acl    = "private"

  versioning {
    enabled = true
  }
}
