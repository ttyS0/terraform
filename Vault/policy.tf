resource "vault_policy" "admin" {
  name = "admin"

  policy = <<EOT
path "*" {
  capabilities = [ "create", "read", "update", "delete", "list", "sudo" ]
}
EOT

}

resource "vault_policy" "autounseal" {
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
