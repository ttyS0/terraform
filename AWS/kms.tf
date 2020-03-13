resource "aws_iam_user" "vault-kms" {
  name = "vault-kms"
}

data aws_iam_policy_document "vault-kms" {
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:DescribeKey"
    ]

    resources = [
      aws_kms_key.vault-kms.arn
    ]

    condition {
      test = "IpAddress"
      values = [
        data.dns_a_record_set.home.addrs[0],
        data.dns_aaaa_record_set.home.addrs[0]
      ]
      variable = "aws:SourceIP"
    }

  }

}

resource "aws_iam_policy" "vault-kms" {
  policy = data.aws_iam_policy_document.vault-kms.json
}

resource "aws_iam_user_policy_attachment" "vault-kms" {
  policy_arn = aws_iam_policy.vault-kms.arn
  user       = aws_iam_user.vault-kms.name
}

data "dns_a_record_set" "home" {
  host = "home.ttys0.net"
}

data "dns_aaaa_record_set" "home" {
  host = "home.ttys0.net"
}

resource aws_kms_key "vault-kms" {
  description = "Vault Auto Unseal"
  deletion_window_in_days = 30
}

output "vault-kms-id" {
  value = aws_kms_key.vault-kms.key_id
}
