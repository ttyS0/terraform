provider "aws" {
  region = "us-east-1"
}

# Route53 Zones
## BEGIN kmjohnson.net
resource "aws_route53_zone" "kmjohnson-net" {
  name = "kmjohnson.net"
}

resource "aws_route53_record" "google_mx" {
  name    = ""
  type    = "MX"
  zone_id = "${aws_route53_zone.kmjohnson-net.zone_id}"

  records = [
    "30 aspmx2.googlemail.com.",
    "30 aspmx3.googlemail.com.",
    "10 aspmx.l.google.com.",
    "20 alt2.aspmx.l.google.com.",
    "20 alt1.aspmx.l.google.com.",
  ]

  ttl = "${var.ttl_24h}"
}

## END kmjohnson.net

