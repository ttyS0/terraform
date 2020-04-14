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
