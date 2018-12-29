variable "ttl_1d" {
  default = "84600"
}

variable "ttl_1h" {
  default = "3600"
}

variable "google_mx" {
  type = "list"

  default = [
    "1 aspmx.l.google.com.",
    "5 alt1.aspmx.l.google.com.",
    "5 alt2.aspmx.l.google.com.",
    "10 alt3.aspmx.l.google.com.",
    "10 alt4.aspmx.l.google.com.",
  ]
}

variable "public_zones" {
  type = "list"

  default = [
    "108minutes.net",
    "beezuscomplex.com",
    "gutenpress.org",
    "kmjohnson.net",
    "seanjohnson.name",
    "seanjohnson.org",
    "seanlab.net",
    "ttys0.net",
  ]
}

variable "home_ip" {
  type    = "string"
  default = "68.53.57.162"
}

variable "ttys0_spf" {
  type    = "string"
  default = "v=spf1 include:_spf.google.com ~all"
}

variable "txt_spf" {
  type = "list"

  default = [
    "TXT",
    "SPF",
  ]
}
