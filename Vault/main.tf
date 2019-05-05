terraform {
  backend "remote" {
    organization = "TTYS0"

    workspaces {
      name = "vault"
    }
  }
}

variable "fqdn" {
  default = "vault.ttys0.net"
}

provider "vault" {
  address = "https://${var.fqdn}"
}

data "terraform_remote_state" "aws" {
  backend = "remote"

  config {
    organization = "TTYS0"

    workspaces = {
      name = "aws"
    }
  }
}
