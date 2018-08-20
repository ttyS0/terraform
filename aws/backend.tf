terraform {
  backend "s3" {
    bucket  = "sean-tfstate"
    key     = "aws.tfstate"
    region  = "us-east-1"
    encrypt = "true"
  }
}
