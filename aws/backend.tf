terraform {
  backend "s3" {
    bucket = "skj-tf-state"
    key = "aws/s3.tfstate"
    region = "us-east-1"
    encrypt = "true"
  }
}
