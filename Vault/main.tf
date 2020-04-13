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

variable "fqdn" {
  default = "vault.ttys0.net"
}

variable "vault_token" {
  default = ""
}

provider "vault" {
  address = "https://${var.fqdn}"
  token = var.vault_token
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
