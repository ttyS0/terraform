terraform {
  backend "remote" {
    organization = "TTYS0"

    workspaces {
      name = "vault"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address = "https://vault.ttys0.net"
}
