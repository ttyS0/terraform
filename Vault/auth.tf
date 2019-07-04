resource "vault_auth_backend" "aws" {
  type = "aws"
}

resource "vault_aws_auth_backend_client" "vault-auth" {
  backend                    = vault_auth_backend.aws.path
  iam_server_id_header_value = var.fqdn
  access_key                 = ""
  lifecycle {
    ignore_changes = [access_key]
  }
}

resource "vault_auth_backend" "approle" {
  type = "approle"
}

resource "vault_approle_auth_backend_role" "cert-manager" {
  role_name = "cert-manager"
  backend   = vault_auth_backend.approle.path
  policies  = [vault_policy.cert-manager.name]
}

resource "vault_approle_auth_backend_role_secret_id" "cert-manager" {
  backend   = vault_auth_backend.approle.path
  role_name = vault_approle_auth_backend_role.cert-manager.role_name
}

# Vault Roles
resource "vault_aws_auth_backend_role" "vault-admin" {
  role                     = "admin"
  backend                  = vault_auth_backend.aws.path
  auth_type                = "iam"
  bound_iam_principal_arns = [data.terraform_remote_state.aws.outputs.vault-admin-role]
  policies                 = [vault_policy.admin.name]
  max_ttl                  = "86400"
  ttl                      = "28800"
}

