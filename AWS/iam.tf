# IAM Users
resource "aws_iam_user" "sean" {
  name = "sean"
}

# Vault Admin Auth
resource "aws_iam_user" "vault-auth" {
  name = "vault-auth"
  path = "/srv/"
}

resource "aws_iam_access_key" "vault-auth" {
  user    = "${aws_iam_user.vault-auth.name}"
  pgp_key = "keybase:ttys0"
}

resource "aws_iam_policy" "vault-auth" {
  policy      = "${data.aws_iam_policy_document.vault-auth.json}"
  name        = "vault-auth"
  description = "Allows lookup of IAM User and Role for validaton by Vault"
}

resource "aws_iam_policy" "vault-admin" {
  policy      = "${data.aws_iam_policy_document.vault-admin.json}"
  name        = "vault-admin"
  description = "Allows STS to role that maps to Vault Admin"
}

resource "aws_iam_user_policy_attachment" "vault-auth" {
  policy_arn = "${aws_iam_policy.vault-auth.arn}"
  user       = "${aws_iam_user.vault-auth.name}"
}

resource "aws_iam_group" "vault-admin" {
  name = "vault-admin"
}

resource "aws_iam_user_group_membership" "vault-admin" {
  groups = ["${aws_iam_group.vault-admin.name}"]
  user   = "${aws_iam_user.sean.name}"
}

resource "aws_iam_group_policy_attachment" "vault-admin" {
  group      = "${aws_iam_group.vault-admin.name}"
  policy_arn = "${aws_iam_policy.vault-admin.arn}"
}

resource "aws_iam_role" "vault-admin" {
  name               = "vault-admin"
  assume_role_policy = "${data.aws_iam_policy_document.vault-admin-trust.json}"
}

data "aws_iam_policy_document" "vault-auth" {
  statement {
    sid    = "AuthenticationToVault"
    effect = "Allow"

    actions = [
      "iam:GetUser",
      "iam:GetRole",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "vault-admin-trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["${aws_iam_user.sean.arn}"]
      type        = "AWS"
    }

    condition {
      test     = "Bool"
      values   = ["true"]
      variable = "aws:MultiFactorAuthPresent"
    }
  }
}

data "aws_iam_policy_document" "vault-admin" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    resources = [
      "${aws_iam_role.vault-admin.arn}",
    ]
  }
}

# Vault AWS
resource "aws_iam_user" "vault-aws" {
  name = "vault-aws"
  path = "/srv/"
}

resource "aws_iam_policy" "vault-aws" {
  policy = "${data.aws_iam_policy_document.vault-aws.json}"
  name   = "vault-aws"
}

resource "aws_iam_user_policy_attachment" "vault-aws" {
  policy_arn = "${aws_iam_policy.vault-aws.arn}"
  user       = "${aws_iam_user.vault-aws.name}"
}

resource "aws_iam_role" "vault-aws-admin" {
  assume_role_policy = "${data.aws_iam_policy_document.vault-aws-admin-trust.json}"
  name               = "vault-aws-admin"
}

resource "aws_iam_role_policy_attachment" "vault-aws-admin" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = "${aws_iam_role.vault-aws-admin.name}"
}

data "aws_iam_policy_document" "vault-aws" {
  statement {
    effect = "Allow"

    actions = [
      "iam:ListAccountAliases",
      "iam:ListUsers",
      "iam:GetAccountPasswordPolicy",
      "iam:GetAccountSummary",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:GetUser",
      "iam:ListAccessKeys",
      "iam:ListUserPolicies",
      "iam:ListAttachedUserPolicies",
      "iam:UpdateAccessKey",
      "iam:ListSigningCertificates",
      "iam:DeleteSigningCertificate",
      "iam:UpdateSigningCertificate",
      "iam:UploadSigningCertificate",
    ]

    resources = [
      "${aws_iam_user.vault-aws.arn}",
    ]
  }
}

data "aws_iam_policy_document" "vault-aws-admin-trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["${aws_iam_user.vault-aws.arn}"]
      type        = "AWS"
    }
  }
}