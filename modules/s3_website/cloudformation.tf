resource "aws_cloudfront_origin_access_identity" "website" {
  comment = "${var.root_domain} via Terraform"
}

resource "aws_route53_record" "website" {
  name    = "${var.root_domain}"
  type    = "A"
  zone_id = "${var.r53_zoneid}"

  alias {
    evaluate_target_health = false
    name                   = "${aws_cloudfront_distribution.website.domain_name}"
    zone_id                = "${aws_cloudfront_distribution.website.hosted_zone_id}"
  }
}

resource "aws_route53_record" "www-website" {
  name    = "www.${var.root_domain}"
  type    = "CNAME"
  zone_id = "${var.r53_zoneid}"
  records = ["${aws_route53_record.website.name}"]
  ttl     = 86400
}

resource "aws_cloudfront_distribution" "website" {
  enabled             = true
  comment             = "${var.root_domain} website"
  default_root_object = "index.html"
  price_class         = "PriceClass_100"

  origin {
    domain_name = "${aws_s3_bucket.website.bucket_domain_name}"
    origin_id   = "S3-${var.root_domain}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.website.cloudfront_access_identity_path}"
    }
  }

  logging_config {
    bucket          = "${var.log_bucket}.s3.amazonaws.com"
    include_cookies = false
    prefix          = "${var.root_domain}.cloudfront"
  }

  aliases = ["${var.root_domain}", "www.${var.root_domain}"]

  "default_cache_behavior" {
    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    "forwarded_values" {
      "cookies" {
        forward = "none"
      }

      query_string = false
    }

    target_origin_id       = "S3-${var.root_domain}"
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
    acm_certificate_arn = "${aws_acm_certificate.website.arn}"
    ssl_support_method  = "sni-only"
  }
}
