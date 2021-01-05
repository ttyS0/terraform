# IAM Users
resource "aws_iam_user" "sean" {
  name = "sean"
}

resource "aws_iam_user_ssh_key" "sean" {
  encoding = "SSH"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDumCrRqbtcApi4chDkQriLIp2Apeev57LMmROsBn4fNwbmWdwe3mWzqIGQIHzfyZMvUs6pJa9MZe5Yy11sDp0GSNZ+EAt6EZsjB36MproGUuTFYdhxoVLPBa+843MsH4VKeW1onMGCBypboXHdEvogorDU3+7j7gP0JPESKujaitA9k+vC35uvVyxKpIcQvR5s6BBI2W7nc1OfrquhZy6TuhmMhYOVKYpGhuF/xtlNGCUQ8oRw5xGV6QcVCWC+3Mm0v7uU8z38C/VpEYMebi2KLvzepfZ9kdrreEsyRPhHwwRzpn8pU4a98R3KoI6uxLl0DuyaldBHqcB0a52Y7Opz sean@nazgul.ttys0.net"
  username = aws_iam_user.sean.name
}


#########

# Ghost IAM User for CDN Buckets
resource "aws_iam_user" "ghost-s3" {
  name = "ghost-s3"
}

data "aws_iam_policy_document" "ghost-s3" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"]

    resources = [
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
//resource "aws_iam_user" "vault-auth" {
//  name = "vault-auth"
//  path = "/srv/"
//}
//
//resource "aws_iam_policy" "vault-auth" {
//  policy      = data.aws_iam_policy_document.vault-auth.json
//  name        = "vault-auth"
//  description = "Allows lookup of IAM User and Role for validaton by Vault"
//}

resource "aws_iam_policy" "vault-admin" {
  policy      = data.aws_iam_policy_document.vault-admin.json
  name        = "vault-admin"
  description = "Allows STS to role that maps to Vault Admin"
}

//resource "aws_iam_user_policy_attachment" "vault-auth" {
//  policy_arn = aws_iam_policy.vault-auth.arn
//  user       = aws_iam_user.vault-auth.name
//}

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
##########

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
    effect = "Allow"
    actions = [
      "sts:AssumeRole"]

    principals {
      identifiers = [
        aws_iam_user.vault-aws.arn]
      type = "AWS"
    }
  }
}

output "vault-aws-admin-role-arn" {
  value = aws_iam_role.vault-aws-admin.arn
}

##########

