output "vault-aws-path" {
  value = vault_aws_secret_backend.aws.path
}

output "vault-aws-role-admin" {
  value = vault_aws_secret_backend_role.admin.name
}

output "cert-manager-roleId" {
  value = data.vault_approle_auth_backend_role_id.cert-manager.role_id
}
