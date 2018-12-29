terraform {
  backend "s3" {
    bucket  = "skj-terraform"
    key     = "dns.tfstate"
    region  = "us-east-1"
    encrypt = "true"
  }
}

provider "aws" {
  region = "us-east-1"
}
