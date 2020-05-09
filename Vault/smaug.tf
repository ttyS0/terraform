provider "vault" {
  alias = "smaug"
  address = "https://${var.smaug}"
  token = data.vault_generic_secret.vault-smaug.data["root"]
}


variable "smaug" {
  default = "smaug.ttys0.net"
}

## Transit Engine

resource "vault_mount" "smaug-transit" {
  provider = vault.smaug
  path = "transit"
  type = "transit"
}

resource "vault_transit_secret_backend_key" "smaug-autounseal" {
  provider = vault.smaug
  backend = vault_mount.transit.path
  name = "autounseal"
  deletion_allowed = false
}


resource "vault_policy" "smaug-admin" {
  provider = vault.smaug
  name = "admin"

  policy = <<EOT
path "*" {
  capabilities = [ "create", "read", "update", "delete", "list", "sudo" ]
}
EOT

}

resource "vault_policy" "smaug-autounseal" {
  provider = vault.smaug
  name = "autounseal"
  policy = <<EOT

path "transit/encrypt/autounseal" {
  capabilities = [ "update" ]
}

path "transit/decrypt/autounseal" {
  capabilities = [ "update" ]
}
EOT
}

resource "vault_auth_backend" "smaug-userpass" {
  provider = vault.smaug
  type = "userpass"
}


