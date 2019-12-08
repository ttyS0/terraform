module "ttys0_net" {
  source = "../modules/cloudflare_zone"
  domain = "ttys0.net"
}

module "beezuscomplex_com" {
  source = "../modules/cloudflare_zone"
  domain = "beezuscomplex.com"
}

module "_108minutes_net" {
  source = "../modules/cloudflare_zone"
  domain = "108minutes.net"
}

module "kmjohnson_net" {
  source = "../modules/cloudflare_zone"
  domain = "kmjohnson.net"
}

module "gutenpress_org" {
  source = "../modules/cloudflare_zone"
  domain = "gutenpress.org"
}

module "tappitytaptap_net" {
  source = "../modules/cloudflare_zone"
  domain = "tappitytaptap.net"
}

module "skj_dev" {
  source = "../modules/cloudflare_zone"
  domain = "skj.dev"
}

module "amateur_dev" {
  source = "../modules/cloudflare_zone"
  domain = "amateur.dev"
}

module "seanjohnson_org" {
  source = "../modules/cloudflare_zone"
  domain = "seanjohnson.org"
}

module "seanjohnson_name" {
  source = "../modules/cloudflare_zone"
  domain = "seanjohnson.name"
}
