terraform {
  backend "remote" {
    organization = "TTYS0"

    workspaces {
      name = "cloudflare"
    }
  }
}

provider "vault" {
  address = "https://vault.ttys0.net"
}

data "vault_generic_secret" "cloudflare" {
  path = "secret/cloudflare"
}

provider "cloudflare" {
  api_key = data.vault_generic_secret.cloudflare.data["global-api-key"]
  email   = data.vault_generic_secret.cloudflare.data["email"]
}



