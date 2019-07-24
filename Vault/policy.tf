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

resource "vault_policy" "cert-manager" {
  name   = "cert-manager"
  policy = <<EOT
# Login with AppRole
path "auth/approle/login" {
  capabilities = [ "create", "read" ]
}

# Sign certs
path "intCA/sign/ttys0-net" {
  capabilities = [ "update", "create" ]
}
path "elasticCA/sign/elastic" {
  capabilities = [ "update", "create" ]
}
EOT
}
