provider "vault" {
  alias = "bombadil"
  address = "https://${var.bombadil}"
  token = data.vault_generic_secret.vault-bombadil.data["root"]
}

variable "bombadil" {
  default = "bombadil.ttys0.net:8200"
}

## Transit Engine

resource "vault_mount" "tom-transit" {
  provider = vault.bombadil
  path = "transit"
  type = "transit"
}

resource "vault_transit_secret_backend_key" "tom-autounseal" {
  provider = vault.bombadil
  backend = vault_mount.transit.path
  name = "autounseal"
  deletion_allowed = false
}

## SSH CA

resource "vault_mount" "tom-ssh" {
  provider = vault.bombadil
  path = "ssh"
  type = "ssh"
}

resource "vault_ssh_secret_backend_ca" "tom-ssh" {
  provider = vault.bombadil
  backend = vault_mount.tom-ssh.path
  generate_signing_key = true

}

resource "vault_ssh_secret_backend_role" "tom-ssh-sean" {
  provider = vault.bombadil
  backend = vault_mount.tom-ssh.path
  key_type = "ca"
  name = "sean"
  allow_user_certificates = true
  allowed_users = "*"
  default_extensions = {
    permit-pty = ""
  }
  default_user = "sean"
  ttl = "7200"
}

resource "vault_policy" "tom-admin" {
  provider = vault.bombadil
  name = "admin"

  policy = <<EOT
path "*" {
  capabilities = [ "create", "read", "update", "delete", "list", "sudo" ]
}
EOT

}

resource "vault_policy" "tom-autounseal" {
  provider = vault.bombadil
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

resource "vault_auth_backend" "tom-userpass" {
  provider = vault.bombadil
  type = "userpass"
}


