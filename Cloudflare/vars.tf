
variable "google_mx_p1" {
  type = list(string)
  default = [
    "aspmx.l.google.com"
  ]
}

variable "google_mx_p5" {
  type = list(string)
  default = [
    "alt1.aspmx.l.google.com",
    "alt2.aspmx.l.google.com"
  ]
}

variable "google_mx_p10" {
  type = list(string)
  default = [
    "alt3.aspmx.l.google.com",
    "alt4.aspmx.l.google.com"
  ]
}

    
variable "domains" {
  type = list(string)
  default = [
    "skj.dev",
    "amateur.dev",
    "ttys0.net",
    "108minutes.net",
    "beezuscomplex.com",
    "gutenpress.org"
  ]
}


