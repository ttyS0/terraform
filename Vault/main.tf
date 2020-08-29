terraform {
  backend "remote" {
    organization = "TTYS0"

    workspaces {
      name = "vault"
    }
  }
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "~> 2.13"
    }
  }
}

variable "home" {
  default = "vault.ttys0.net"
}

variable "home_token" {
  default = ""
}


provider "vault" {
  address = "https://${var.home}"
  token   = var.home_token
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
  path = "secrets/aws/vault-aws"
}


resource "vault_mount" "transit" {
  path = "transit"
  type = "transit"
}

resource "vault_auth_backend" "userpass" {
  type = "userpass"
}
