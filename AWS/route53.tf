## Vars
variable "ttl_1d" {
  default = "84600"
}

variable "ttl_1h" {
  default = "3600"
}

variable "google_mx" {
  type = list(string)

  default = [
    "1 aspmx.l.google.com.",
    "5 alt1.aspmx.l.google.com.",
    "5 alt2.aspmx.l.google.com.",
    "10 alt3.aspmx.l.google.com.",
    "10 alt4.aspmx.l.google.com.",
  ]
}

variable "public_zones" {
  type = list(string)

  default = [
    "108minutes.net",
    "beezuscomplex.com",
    "gutenpress.org",
    "kmjohnson.net",
    "ttys0.net",
  ]
}

variable "ttys0_spf" {
  type    = string
  default = "v=spf1 include:_spf.google.com ~all"
}

variable "txt_spf" {
  type = list(string)

  default = [
    "TXT",
    "SPF",
  ]
}

## Resources
resource "aws_route53_zone" "public_zone" {
  count = length(var.public_zones)
  name  = var.public_zones[count.index]
}

resource "aws_route53_record" "google_mx" {
  count   = length(var.public_zones)
  name    = ""
  type    = "MX"
  zone_id = aws_route53_zone.public_zone.*.zone_id[count.index]
  records = var.google_mx
  ttl     = var.ttl_1d
}

## ttys0.net records
resource "aws_route53_record" "ttys0_spf" {
  count   = length(var.txt_spf)
  name    = ""
  type    = var.txt_spf[count.index]
  zone_id = aws_route53_zone.public_zone.*.zone_id[4]
  ttl     = var.ttl_1d
  records = [var.ttys0_spf]
}

## Outputs
output "zones" {
  value = zipmap(var.public_zones, aws_route53_zone.public_zone.*.zone_id)
}

