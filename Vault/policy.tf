resource "vault_policy" "admin" {
  name = "admin"

  policy = <<EOT
path "*" {
  capabilities = [ "create", "read", "update", "delete", "list", "sudo" ]
}
EOT
}
