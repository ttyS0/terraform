variable "domain" {}


resource "cloudflare_zone" "zone" {
  zone = var.domain
  plan = "free"
  type = "full"
}

resource "cloudflare_record" "aspmx" {
  name     = var.domain
  value    = "aspmx.l.google.com"
  priority = "1"
  type     = "MX"
  zone_id  = cloudflare_zone.zone.id
}

resource "cloudflare_record" "alt1" {
  name     = var.domain
  value    = "alt1.aspmx.l.google.com"
  priority = "5"
  type     = "MX"
  zone_id  = cloudflare_zone.zone.id
}

resource "cloudflare_record" "alt2" {
  name     = var.domain
  value    = "alt2.aspmx.l.google.com"
  priority = "5"
  type     = "MX"
  zone_id  = cloudflare_zone.zone.id
}

resource "cloudflare_record" "alt3" {
  name     = var.domain
  value    = "alt3.aspmx.l.google.com"
  priority = "10"
  type     = "MX"
  zone_id  = cloudflare_zone.zone.id
}

resource "cloudflare_record" "alt4" {
  name     = var.domain
  value    = "alt4.aspmx.l.google.com"
  priority = "10"
  type     = "MX"
  zone_id  = cloudflare_zone.zone.id
}

output "zoneid" {
  value = cloudflare_zone.zone.id
}
