resource "aws_acm_certificate" "108minutes" {
  domain_name               = "108minutes.net"
  validation_method         = "DNS"
  subject_alternative_names = ["www.108minutes.net"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "108minutes_cert_validation" {
  name    = "${aws_acm_certificate.108minutes.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.108minutes.domain_validation_options.0.resource_record_type}"
  zone_id = "${lookup(data.terraform_remote_state.dns.zones["108minutes"], "net")}"
  records = ["${aws_acm_certificate.108minutes.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "www_108minutes_cert_validation" {
  name    = "${aws_acm_certificate.108minutes.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.108minutes.domain_validation_options.0.resource_record_type}"
  zone_id = "${lookup(data.terraform_remote_state.dns.zones["108minutes"], "net")}"
  records = ["${aws_acm_certificate.108minutes.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "108minutes" {
  certificate_arn = "${aws_acm_certificate.108minutes.arn}"

  validation_record_fqdns = [
    "${aws_route53_record.108minutes_cert_validation.fqdn}",
    "${aws_route53_record.www_108minutes_cert_validation.fqdn}",
  ]
}

resource "aws_acm_certificate" "ttys0" {
  domain_name               = "ttys0.net"
  validation_method         = "DNS"
  subject_alternative_names = ["www.ttys0.net"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "ttys0_cert_validation" {
  name    = "${aws_acm_certificate.ttys0.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.ttys0.domain_validation_options.0.resource_record_type}"
  zone_id = "${lookup(data.terraform_remote_state.dns.zones["ttys0"], "net")}"
  records = ["${aws_acm_certificate.ttys0.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "www_ttys0_cert_validation" {
  name    = "${aws_acm_certificate.ttys0.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.ttys0.domain_validation_options.0.resource_record_type}"
  zone_id = "${lookup(data.terraform_remote_state.dns.zones["ttys0"], "net")}"
  records = ["${aws_acm_certificate.ttys0.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "ttys0" {
  certificate_arn = "${aws_acm_certificate.ttys0.arn}"

  validation_record_fqdns = [
    "${aws_route53_record.ttys0_cert_validation.fqdn}",
    "${aws_route53_record.www_ttys0_cert_validation.fqdn}",
  ]
}

resource "aws_acm_certificate" "beezuscomplex" {
  domain_name               = "beezuscomplex.com"
  validation_method         = "DNS"
  subject_alternative_names = ["www.beezuscomplex.com"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "beezuscomplex_cert_validation" {
  name    = "${aws_acm_certificate.beezuscomplex.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.beezuscomplex.domain_validation_options.0.resource_record_type}"
  zone_id = "${lookup(data.terraform_remote_state.dns.zones["beezuscomplex"], "com")}"
  records = ["${aws_acm_certificate.beezuscomplex.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_route53_record" "www_beezuscomplex_cert_validation" {
  name    = "${aws_acm_certificate.beezuscomplex.domain_validation_options.1.resource_record_name}"
  type    = "${aws_acm_certificate.beezuscomplex.domain_validation_options.0.resource_record_type}"
  zone_id = "${lookup(data.terraform_remote_state.dns.zones["beezuscomplex"], "com")}"
  records = ["${aws_acm_certificate.beezuscomplex.domain_validation_options.1.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "beezuscomplex" {
  certificate_arn = "${aws_acm_certificate.beezuscomplex.arn}"

  validation_record_fqdns = [
    "${aws_route53_record.beezuscomplex_cert_validation.fqdn}",
    "${aws_route53_record.www_beezuscomplex_cert_validation.fqdn}",
  ]
}
