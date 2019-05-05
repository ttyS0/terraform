output "vault-auth-accessKey" {
  value = "${aws_iam_access_key.vault-auth.id}"
}

output "vault-auth-secretKey" {
  value = "${aws_iam_access_key.vault-auth.encrypted_secret}"
}

output "vault-admin-role" {
  value = "${aws_iam_role.vault-admin.arn}"
}

output "vault-aws-admin-role" {
  value = "${aws_iam_role.vault-aws-admin.arn}"
}

output "vault-aws-admin-leaseid" {
  value = "${data.vault_aws_access_credentials.admin-creds.lease_id}"
}
