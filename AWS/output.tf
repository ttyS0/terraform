output "vault-auth-accessKey" {
  value = "${aws_iam_access_key.vault-auth.id}"
}

output "vault-auth-secretKey" {
  value = "${aws_iam_access_key.vault-auth.encrypted_secret}"
}

output "vault-admin-role" {
  value = "${aws_iam_role.vault-admin.arn}"
}
