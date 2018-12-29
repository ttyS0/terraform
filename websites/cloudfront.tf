resource "aws_cloudfront_origin_access_identity" "108minutes" {
  comment = "108minutes.net"
}

resource "aws_route53_record" "108minutes" {
  name    = "108minutes.net"
  type    = "A"
  zone_id = "${lookup(data.terraform_remote_state.dns.zones["108minutes"], "net")}"

  alias {
    evaluate_target_health = false
    name                   = "${aws_cloudfront_distribution.108minutes.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.108minutes.hosted_zone_id}"
  }
}

resource "aws_route53_record" "www-108minutes" {
  name    = "www.108minutes.net"
  type    = "CNAME"
  zone_id = "${lookup(data.terraform_remote_state.dns.zones["108minutes"], "net")}"
  records = ["${aws_route53_record.108minutes.name}"]
  ttl     = 86400
}

resource "aws_cloudfront_distribution" "108minutes" {
  enabled             = true
  comment             = "108minutes.net website"
  default_root_object = "index.html"
  price_class         = "PriceClass_100"

  origin {
    domain_name = "${aws_s3_bucket.108minutes.bucket_regional_domain_name}"
    origin_id   = "S3-108minutes"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.108minutes.cloudfront_access_identity_path}"
    }
  }

  logging_config {
    bucket          = "${aws_s3_bucket.logs.bucket_domain_name}"
    include_cookies = false
    prefix          = "108minutes-cloudfront"
  }

  aliases = ["www.108minutes.net"]

  "default_cache_behavior" {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    "forwarded_values" {
      "cookies" {
        forward = "none"
      }

      query_string = false
    }

    target_origin_id       = "S3-108minutes"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  "restrictions" {
    "geo_restriction" {
      restriction_type = "none"
    }
  }

  "viewer_certificate" {
    acm_certificate_arn      = "${aws_acm_certificate.108minutes.arn}"
    minimum_protocol_version = "TLSv1.1_2016"
    ssl_support_method       = "sni-only"
  }
}

resource "aws_cloudfront_origin_access_identity" "ttys0" {
  comment = "ttys0.net"
}
