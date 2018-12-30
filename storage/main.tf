terraform {
  backend "s3" {
    bucket  = "skj-terraform"
    key     = "storage.tfstate"
    region  = "us-east-1"
    encrypt = "true"
  }
}

provider "aws" {
  region = "us-east-1"
}

data "terraform_remote_state" "dns" {
  backend = "s3"

  config {
    bucket  = "skj-terraform"
    key     = "dns.tfstate"
    region  = "us-east-1"
    encrypt = "true"
  }
}

output "website-logs" {
  value = "${aws_s3_bucket.web_logs.id}"
}

output "terraform" {
  value = "${aws_s3_bucket.terraform_state.id}"
}
