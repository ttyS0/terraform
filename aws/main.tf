provider "aws" {
  region = "us-east-1"
}

# Route53 Zones
## BEGIN kmjohnson.net
resource "aws_route53_zone" "kmjohnson-net" {
  name = "kmjohnson.net"
}

resource "aws_route53_record" "kmjohnson_mx" {
  name    = ""
  type    = "MX"
  zone_id = "${aws_route53_zone.kmjohnson-net.zone_id}"
  records = "${var.google_mx}"
  ttl     = "${var.ttl_1h}"
}

## END kmjohnson.net

## BEGIN gutenpress.org
resource "aws_route53_zone" "gutenpress-org" {
  name = "gutenpress.org"
}

resource "aws_route53_record" "gutenpress_mx" {
  name    = ""
  type    = "MX"
  zone_id = "${aws_route53_zone.gutenpress-org.zone_id}"
  records = "${var.google_mx}"
  ttl     = "${var.ttl_1h}"
}

## END gutenpress.org

## BEGIN vumc.cloud
resource "aws_route53_zone" "vumc-cloud" {
  name = "vumc.cloud"
}

## END vumc.cloud

