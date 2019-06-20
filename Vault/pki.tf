resource "vault_pki_secret_backend" "rootCA" {
  path        = "rootCA"
  description = "Home Root CA"
}


resource "vault_pki_secret_backend" "intCA" {
  path        = "intCA"
  description = "Home Intermediate CA"
}

resource "vault_pki_secret_backend" "k8s" {
  path        = "k8s-pki"
  description = "Kubernetes Certificate Chain"
}

resource "vault_mount" "sshCA" {
  path = "sshCA"
  type = "ssh"
}

resource "vault_ssh_secret_backend_ca" "sshCA" {
  backend = vault_mount.sshCA.path
}

resource "vault_ssh_secret_backend_role" "home" {
  backend                 = vault_mount.sshCA.path
  key_type                = "ca"
  name                    = "home"
  default_user            = "sean"
  allowed_users           = "*"
  allow_user_certificates = true
  max_ttl                 = "86400"
  ttl                     = "3600"
  default_extensions = {
    permit-pty = ""
  }
}
