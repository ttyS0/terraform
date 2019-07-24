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

resource "vault_pki_secret_backend" "elasticCA" {
  path                  = "elasticCA"
  max_lease_ttl_seconds = 31536000 # one year
  description           = "Elasticsearch CA"
}

resource "vault_pki_secret_backend_root_cert" "elasticCA" {
  depends_on           = [vault_pki_secret_backend.elasticCA]
  backend              = vault_pki_secret_backend.elasticCA.path
  common_name          = "Elasticsearch CA"
  type                 = "internal"
  exclude_cn_from_sans = true
  format               = "pem"
  ttl                  = "31536000"
}

resource "vault_pki_secret_backend_role" "elastic" {
  backend            = vault_pki_secret_backend.elasticCA.path
  name               = "elastic"
  allowed_domains    = ["instance", "es-master", "es-master-0", "es-master-1", "es-master-2"]
  allow_bare_domains = true
  allow_subdomains   = true
  allow_glob_domains = true
  allow_localhost    = true
  require_cn         = false
  enforce_hostnames  = false
  key_usage = [
    "DigitalSignature",
    "KeyAgreement",
    "KeyEncipherment"
  ]
}
