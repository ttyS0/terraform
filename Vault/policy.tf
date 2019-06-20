resource "vault_policy" "admin" {
  name = "admin"

  policy = <<EOT
path "*" {
  capabilities = [ "create", "read", "update", "delete", "list", "sudo" ]
}
EOT

}

resource "vault_policy" "consul-s3" {
  name = "consul-s3"
  policy = <<EOT
path "aws/sts/consul-s3" {
  capabilities = [ "read" ]
}
EOT

}

