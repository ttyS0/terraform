resource "cloudflare_record" "beezuscomplex_cdn" {
  name    = "cdn"
  value   = "d1shbcuo0gp4wh.cloudfront.net"
  type    = "CNAME"
  proxied = true
  zone_id = module.beezuscomplex_com.zoneid
}

resource "cloudflare_record" "_108minutes_cdn" {
  name    = "cdn"
  type    = "CNAME"
  value   = "d1n6u6u7xoml73.cloudfront.net"
  proxied = true
  zone_id = module._108minutes_net.zoneid
}

resource "cloudflare_record" "ttys0_home-ipv4" {
  name    = "home.ttys0.net"
  type    = "A"
  proxied = false
  value   = data.dns_a_record_set.home.addrs[0]
  zone_id = module.ttys0_net.zoneid

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

resource "cloudflare_record" "ttys0_home-ipv6" {
  name    = "home.ttys0.net"
  type    = "AAAA"
  proxied = true
  value   = data.dns_aaaa_record_set.home.addrs[0]
  zone_id = module.ttys0_net.zoneid

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}


data "dns_a_record_set" "home" {
  host = "home.ttys0.net"
}

data "dns_aaaa_record_set" "home" {
  host = "home.ttys0.net"
}

resource "cloudflare_record" "beezuscomplex_apex" {
  name    = "beezuscomplex.com"
  type    = "CNAME"
  value   = cloudflare_record.ttys0_home-ipv4.hostname
  proxied = true
  zone_id = module.beezuscomplex_com.zoneid
}

resource "cloudflare_record" "beezuscomplex_www" {
  name    = "www"
  type    = "CNAME"
  value   = cloudflare_record.beezuscomplex_apex.hostname
  proxied = true
  zone_id = module.beezuscomplex_com.zoneid
}

resource "cloudflare_record" "_108minutes_apex" {
  name    = "108minutes.net"
  type    = "CNAME"
  proxied = true
  value   = cloudflare_record.ttys0_home-ipv4.hostname
  zone_id = module._108minutes_net.zoneid
}

resource "cloudflare_record" "_108minutes_www" {
  name    = "www"
  type    = "CNAME"
  value   = cloudflare_record._108minutes_apex.hostname
  proxied = true
  zone_id = module._108minutes_net.zoneid
}

resource "cloudflare_record" "_108minutes_pics" {
  name    = "pics"
  type    = "CNAME"
  proxied = false
  value   = "domains.smugmug.com"
  zone_id = module._108minutes_net.zoneid
}

resource "cloudflare_record" "ttys0_minecraft" {
  name    = "minecraft"
  type    = "CNAME"
  proxied = false
  value   = cloudflare_record.ttys0_home-ipv4.hostname
  zone_id = module.ttys0_net.zoneid
}

resource "cloudflare_record" "ttys0_vault" {
  name    = "vault"
  type    = "CNAME"
  proxied = true
  value   = cloudflare_record.ttys0_home-ipv4.hostname
  zone_id = module.ttys0_net.zoneid
}

resource "cloudflare_record" "ttys0_apex" {
  name    = "ttys0.net"
  type    = "CNAME"
  proxied = true
  value   = "ttys0.github.io"
  zone_id = module.ttys0_net.zoneid
}

resource "cloudflare_record" "ttys0_www" {
  name    = "www"
  type    = "CNAME"
  proxied = true
  value   = "ttys0.github.io"
  zone_id = module.ttys0_net.zoneid
}

resource "cloudflare_record" "skj_apex" {
  name    = "skj.dev"
  type    = "CNAME"
  proxied = true
  value   = "ttys0.github.io"
  zone_id = module.skj_dev.zoneid
}

resource "cloudflare_record" "skj_www" {
  name    = "www"
  type    = "CNAME"
  proxied = true
  value   = "ttys0.github.io"
  zone_id = module.skj_dev.zoneid
}
