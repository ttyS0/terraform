terraform {
  backend "remote" {
    organization = "TTYS0"

    workspaces {
      name = "aws"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = data.vault_aws_access_credentials.admin-creds.access_key
  secret_key = data.vault_aws_access_credentials.admin-creds.secret_key
  token      = data.vault_aws_access_credentials.admin-creds.security_token
}

provider "vault" {
  address = "https://vault.ttys0.net"
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

# Ghost Website CDNs
module "ghost-108minutes" {
  source = "../modules/ghost-cdn"
  name   = "ghost-108minutes-net"
  domain = "108minutes.net"
}

module "ghost-beezuscomplex" {
  source = "../modules/ghost-cdn"
  name   = "ghost-beezuscomplex-com"
  domain = "beezuscomplex.com"
}

