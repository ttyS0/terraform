# AWS Secret Engines

resource "vault_aws_secret_backend" "aws" {
  access_key = data.vault_generic_secret.vault-aws.data["accessID"]
  secret_key = data.vault_generic_secret.vault-aws.data["secretKey"]
  path = "aws"
  region = "us-east-1"
  max_lease_ttl_seconds = 86400
  default_lease_ttl_seconds = 3600
}

resource "vault_aws_secret_backend_role" "admin" {
  backend         = vault_aws_secret_backend.aws.path
  credential_type = "assumed_role"
  name            = "admin"

  role_arns = [
    data.terraform_remote_state.aws.outputs.vault-aws-admin-role-arn]
}

