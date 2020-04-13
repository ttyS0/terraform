# Archival Bucket
resource "aws_s3_bucket" "skj-archive" {
  bucket = "skj-archive"
  acl    = "private"

  versioning {
    enabled = false
  }

  lifecycle_rule {
    enabled = true
    id = "clear_stale_uploads"
    abort_incomplete_multipart_upload_days = 1

  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "skj-archive" {
  bucket                  = aws_s3_bucket.skj-archive.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


