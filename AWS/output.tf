output "vault-admin-role" {
  value = "${aws_iam_role.vault-admin.arn}"
}

output "vault-aws-admin-role" {
  value = "${aws_iam_role.vault-aws-admin.arn}"
}

output "vault-aws-admin-leaseid" {
  value = "${data.vault_aws_access_credentials.admin-creds.lease_id}"
}

output "vault-aws-consul-s3-role" {
  value = "${aws_iam_role.consul-s3.arn}"
}
