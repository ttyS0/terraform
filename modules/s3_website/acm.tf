resource "aws_acm_certificate" "website" {
  domain_name               = "${var.root_domain}"
  validation_method         = "DNS"
  subject_alternative_names = ["www.${var.root_domain}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "root_cert_validation" {
  name    = "${aws_acm_certificate.website.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.website.domain_validation_options.0.resource_record_type}"
  zone_id = "${var.r53_zoneid}"
  records = ["${aws_acm_certificate.website.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "www_cert_validation" {
  name    = "${aws_acm_certificate.website.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.website.domain_validation_options.0.resource_record_type}"
  zone_id = "${var.r53_zoneid}"
  records = ["${aws_acm_certificate.website.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "website" {
  certificate_arn = "${aws_acm_certificate.website.arn}"

  validation_record_fqdns = [
    "${aws_route53_record.root_cert_validation.fqdn}",
    "${aws_route53_record.www_cert_validation.fqdn}",
  ]
}
