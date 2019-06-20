# IAM Users
resource "aws_iam_user" "sean" {
  name = "sean"
}

# Ghost IAM User for CDN Buckets
resource "aws_iam_user" "ghost-s3" {
  name = "ghost-s3"
}

data "aws_iam_policy_document" "ghost-s3" {
  statement {
    effect  = "Allow"
    actions = ["s3:ListBucket"]

    resources = [
      module.ghost-108minutes.ghost-bucket-arn,
      module.ghost-beezuscomplex.ghost-bucket-arn,
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:PutObjectVersionACL",
      "s3:DeleteObject",
      "s3:PutObjectAcl",
    ]

    resources = [
      "${module.ghost-108minutes.ghost-bucket-arn}/*",
      "${module.ghost-beezuscomplex.ghost-bucket-arn}/*",
    ]
  }
}

resource "aws_iam_policy" "ghost-s3" {
  policy = data.aws_iam_policy_document.ghost-s3.json
}

resource "aws_iam_user_policy_attachment" "ghost-s3" {
  policy_arn = aws_iam_policy.ghost-s3.arn
  user       = aws_iam_user.ghost-s3.name
}

# Vault Admin Auth
resource "aws_iam_user" "vault-auth" {
  name = "vault-auth"
  path = "/srv/"
}

resource "aws_iam_policy" "vault-auth" {
  policy      = data.aws_iam_policy_document.vault-auth.json
  name        = "vault-auth"
  description = "Allows lookup of IAM User and Role for validaton by Vault"
}

resource "aws_iam_policy" "vault-admin" {
  policy      = data.aws_iam_policy_document.vault-admin.json
  name        = "vault-admin"
  description = "Allows STS to role that maps to Vault Admin"
}

resource "aws_iam_user_policy_attachment" "vault-auth" {
  policy_arn = aws_iam_policy.vault-auth.arn
  user       = aws_iam_user.vault-auth.name
}

resource "aws_iam_group" "vault-admin" {
  name = "vault-admin"
}

resource "aws_iam_user_group_membership" "vault-admin" {
  groups = [aws_iam_group.vault-admin.name]
  user   = aws_iam_user.sean.name
}

resource "aws_iam_group_policy_attachment" "vault-admin" {
  group      = aws_iam_group.vault-admin.name
  policy_arn = aws_iam_policy.vault-admin.arn
}

resource "aws_iam_role" "vault-admin" {
  name               = "vault-admin"
  assume_role_policy = data.aws_iam_policy_document.vault-admin-trust.json
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
      identifiers = [aws_iam_user.sean.arn]
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
      aws_iam_role.vault-admin.arn,
    ]
  }
}

# Vault AWS
resource "aws_iam_user" "vault-aws" {
  name = "vault-aws"
  path = "/srv/"
}

resource "aws_iam_policy" "vault-aws" {
  policy = data.aws_iam_policy_document.vault-aws.json
  name   = "vault-aws"
}

resource "aws_iam_user_policy_attachment" "vault-aws" {
  policy_arn = aws_iam_policy.vault-aws.arn
  user       = aws_iam_user.vault-aws.name
}

resource "aws_iam_role" "vault-aws-admin" {
  assume_role_policy   = data.aws_iam_policy_document.vault-aws-admin-trust.json
  name                 = "vault-aws-admin"
  max_session_duration = "43200"
}

resource "aws_iam_role_policy_attachment" "vault-aws-admin" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.vault-aws-admin.name
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
      aws_iam_user.vault-aws.arn,
    ]
  }
}

data "aws_iam_policy_document" "vault-aws-admin-trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = [aws_iam_user.vault-aws.arn]
      type        = "AWS"
    }
  }
}

## Consul Backup
resource "aws_iam_policy" "consul-s3" {
  policy = data.aws_iam_policy_document.consul-s3.json
  name   = "vault-consul-s3"
}

resource "aws_iam_role" "consul-s3" {
  assume_role_policy   = data.aws_iam_policy_document.vault-aws-admin-trust.json
  name                 = "vault-consul-s3"
  max_session_duration = "3600"
}

resource "aws_iam_role_policy_attachment" "consul-s3" {
  policy_arn = aws_iam_policy.consul-s3.arn
  role       = aws_iam_role.consul-s3.name
}

data "aws_iam_policy_document" "consul-s3" {
  statement {
    effect  = "Allow"
    actions = ["s3:ListBucket"]

    resources = [
      aws_s3_bucket.skj-backups.arn,
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.skj-backups.arn}/consul/*",
    ]
  }
}

