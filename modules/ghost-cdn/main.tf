variable "name" {
  description = "site name"
}

variable "acl" {
  description = "bucket acl"
  default = "private"
}

variable "domain" {
  description = "root domain name"
}

resource "aws_s3_bucket" "ghost-bucket" {
  bucket = "${var.name}"
  acl = "${var.acl}"
  policy = "${data.aws_iam_policy_document.ghost-bucket.json}"
  versioning {
    enabled = true
  }
}

data "aws_iam_policy_document" "ghost-bucket" {
  statement {
    effect = "Allow"
    actions = ["s3:GetObject"]
    principals {
      identifiers = ["*"]
      type = "*"
    }
    resources = ["arn:aws:s3:::${var.name}/*"]
  }
}

locals {
  s3_origin_id = "S3-${var.name}"
  fqdn = "cdn.${var.domain}"
}

resource "aws_cloudfront_origin_access_identity" "ghost-cdn" {}

resource "aws_cloudfront_distribution" "ghost-cdn" {
  enabled = true
  is_ipv6_enabled = true
  comment = "Ghost CDN for ${var.name}"
  aliases = ["${local.fqdn}"]
  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]
    cached_methods = ["GET", "HEAD"]
    target_origin_id = "${local.s3_origin_id}"
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
    compress = true
  }

  origin {
    domain_name = "${aws_s3_bucket.ghost-bucket.bucket_domain_name}"
    origin_id = "${local.s3_origin_id}"
    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.ghost-cdn.cloudfront_access_identity_path}"
    }
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn = "${aws_acm_certificate.ghost-cdn.arn}"
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }
  price_class = "PriceClass_100"
}

resource "aws_acm_certificate" "ghost-cdn" {
  domain_name = "${local.fqdn}"
  validation_method = "DNS"
}

data "aws_route53_zone" "dns" {
  name = "${var.domain}."
  private_zone = false
}

resource "aws_route53_record" "cert_validation" {
  name = "${aws_acm_certificate.ghost-cdn.domain_validation_options.0.resource_record_name}"
  type = "${aws_acm_certificate.ghost-cdn.domain_validation_options.0.resource_record_type}"
  zone_id = "${data.aws_route53_zone.dns.zone_id}"
  records = ["${aws_acm_certificate.ghost-cdn.domain_validation_options.0.resource_record_value}"]
  ttl = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = "${aws_acm_certificate.ghost-cdn.arn}"
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}

resource "aws_route53_record" "cdn_alias" {
  name = "${local.fqdn}"
  type = "A"
  zone_id = "${data.aws_route53_zone.dns.zone_id}"
  alias {
    evaluate_target_health = false
    name = "${aws_cloudfront_distribution.ghost-cdn.domain_name}"
    zone_id = "${aws_cloudfront_distribution.ghost-cdn.hosted_zone_id}"
  }
}
