resource "aws_route53_zone" "public_zone" {
  count = "${length(var.public_zones)}"
  name  = "${var.public_zones[count.index]}"
}

resource "aws_route53_record" "google_mx" {
  count   = "${length(var.public_zones)}"
  name    = ""
  type    = "MX"
  zone_id = "${element(aws_route53_zone.public_zone.*.zone_id, count.index)}"
  records = "${var.google_mx}"
  ttl     = "${var.ttl_1d}"
}

## ttys0.net records
resource "aws_route53_record" "ttys0_spf" {
  count   = "${length(var.txt_spf)}"
  name    = ""
  type    = "${var.txt_spf[count.index]}"
  zone_id = "${element(aws_route53_zone.public_zone.*.zone_id, 7)}"
  ttl     = "${var.ttl_1d}"
  records = ["${var.ttys0_spf}"]
}

resource "aws_route53_record" "ttys0_home" {
  name    = "home.ttys0.net"
  type    = "A"
  zone_id = "${element(aws_route53_zone.public_zone.*.zone_id, 7)}"
  ttl     = "${var.ttl_1d}"
  records = ["${var.home_ip}"]
}
