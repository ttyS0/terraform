variable "ttl_24h" {
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
