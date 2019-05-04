terraform {
  backend "remote" {
    organization = "TTYS0"

    workspaces {
      name = "aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address = "https://vault.ttys0.net"
}


# Ghost Website CDNs
module "ghost-108minutes" {
  source = "../modules/ghost-cdn"
  name = "ghost-108minutes-net"
  domain = "108minutes.net"
}

module "ghost-beezuscomplex" {
  source = "../modules/ghost-cdn"
  name = "ghost-beezuscomplex-com"
  domain = "beezuscomplex.com"
}
