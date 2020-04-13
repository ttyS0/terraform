terraform {
  backend "remote" {
    organization = "TTYS0"

    workspaces {
      name = "cloudflare"
    }
  }

  required_providers {
    vault = "~> 2.10"
    cloudflare = "~> 2.5.1"
    dns = "~> 2.2"
  }
}

variable "vault_token" {
  default = ""
}

provider "vault" {
  address = "https://vault.ttys0.net"
  token = var.vault_token
}

data "vault_generic_secret" "cloudflare" {
  path = "vault/cloudflare"
}

provider "cloudflare" {
  api_key = data.vault_generic_secret.cloudflare.data["global-api-key"]
  email   = data.vault_generic_secret.cloudflare.data["email"]
}

