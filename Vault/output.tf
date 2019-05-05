output "vault-aws-path" {
  value = "${vault_aws_secret_backend.aws.path}"
}

output "vault-aws-role-admin" {
  value = "${vault_aws_secret_backend_role.admin.name}"
}
