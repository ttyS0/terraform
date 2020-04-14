terraform {
  backend "remote" {
    organization = "TTYS0"

    workspaces {
      name = "aws"
    }
  }

  required_providers {
    aws = "~> 2.57"
    dns = "~> 2.2"
    vault = "~> 2.10"
    http = "~> 1.2.0"
  }

  required_version = ">= 0.12"
}

provider "aws" {
  region     = "us-east-1"
  access_key = data.vault_aws_access_credentials.admin-creds.access_key
  secret_key = data.vault_aws_access_credentials.admin-creds.secret_key
  token      = data.vault_aws_access_credentials.admin-creds.security_token
}

variable "vault_token" {
  default = ""
}

provider "vault" {
  address = "https://vault.ttys0.net"
  token = var.vault_token
}

data "terraform_remote_state" "vault" {
  backend = "remote"

  config = {
    organization = "TTYS0"
    workspaces = {
      name = "vault"
    }
  }
}

data "vault_aws_access_credentials" "admin-creds" {
  backend = data.terraform_remote_state.vault.outputs.vault-aws-path
  role    = data.terraform_remote_state.vault.outputs.vault-aws-role-admin
  type    = "sts"
}

## Modules
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

data "http" "public_ipv4" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  pubip = chomp(data.http.public_ipv4.body)
}

resource "aws_default_vpc" "vpc" {

}

resource "aws_key_pair" "home" {
  key_name = "home"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDumCrRqbtcApi4chDkQriLIp2Apeev57LMmROsBn4fNwbmWdwe3mWzqIGQIHzfyZMvUs6pJa9MZe5Yy11sDp0GSNZ+EAt6EZsjB36MproGUuTFYdhxoVLPBa+843MsH4VKeW1onMGCBypboXHdEvogorDU3+7j7gP0JPESKujaitA9k+vC35uvVyxKpIcQvR5s6BBI2W7nc1OfrquhZy6TuhmMhYOVKYpGhuF/xtlNGCUQ8oRw5xGV6QcVCWC+3Mm0v7uU8z38C/VpEYMebi2KLvzepfZ9kdrreEsyRPhHwwRzpn8pU4a98R3KoI6uxLl0DuyaldBHqcB0a52Y7Opz sean@nazgul.ttys0.net"
}
