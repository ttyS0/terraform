output "vault-aws-path" {
  value = vault_aws_secret_backend.aws.path
}

output "vault-aws-role-admin" {
  value = vault_aws_secret_backend_role.admin.name
}

output "cert-manager-roleId" {
  value = vault_approle_auth_backend_role.cert-manager.role_id
}
output "cert-manager-secretId" {
  value     = vault_approle_auth_backend_role_secret_id.cert-manager.secret_id
  sensitive = true
}
