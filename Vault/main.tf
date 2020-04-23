terraform {
  backend "remote" {
    organization = "TTYS0"

    workspaces {
      name = "vault"
    }
  }
  required_providers {
    vault = "~> 2.10"
  }

  required_version = ">= 0.12"
}

variable "home" {
  default = "vault.ttys0.net"
}

variable "home_token" {
  default = ""
}


provider "vault" {
  address = "https://${var.home}"
  token = var.home_token
}


data "terraform_remote_state" "aws" {
  backend = "remote"

  config = {
    organization = "TTYS0"
    workspaces = {
      name = "aws"
    }
  }
}

data "vault_generic_secret" "vault-aws" {
  path = "vault/aws/vault-aws"
}

data "vault_generic_secret" "vault-bombadil" {
  path = "vault/bombadil/vault"
}

resource "vault_mount" "transit" {
  path = "transit"
  type = "transit"
}

resource "vault_transit_secret_backend_key" "autounseal" {
  backend = vault_mount.transit.path
  name = "autounseal"
  deletion_allowed = false
}

resource "vault_auth_backend" "userpass" {
  type = "userpass"
}
