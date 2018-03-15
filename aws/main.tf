provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "website-ttys0net" {
  bucket = "website-ttys0net"
  acl = "public-read"
  website {
    index_document = "index.html"
  }
  tags {
    Type = "website"
  }
}

resource "aws_s3_bucket_policy" "website-bucket-read" {
  bucket = "${aws_s3_bucket.website-ttys0net.id}"
  policy = "${data.aws_iam_policy_document.website-bucket-read.json}"
}
