module "108minutes" {
  source = "../modules/s3_website"

  root_domain = "108minutes.net"
  r53_zoneid  = "${lookup(data.terraform_remote_state.dns.zones["108minutes"], "net")}"
  log_bucket  = "${data.terraform_remote_state.storage.website-logs}"
}

module "ttys0" {
  source = "../modules/s3_website"

  root_domain = "ttys0.net"
  r53_zoneid  = "${lookup(data.terraform_remote_state.dns.zones["ttys0"], "net")}"
  log_bucket  = "${data.terraform_remote_state.storage.website-logs}"
}

module "beezuscomplex" {
  source = "../modules/s3_website"

  root_domain = "beezuscomplex.com"
  r53_zoneid  = "${lookup(data.terraform_remote_state.dns.zones["beezuscomplex"], "com")}"
  log_bucket  = "${data.terraform_remote_state.storage.website-logs}"
}
