provider "aws" {
  region = "us-east-1"
  version = "~> 2.12.0"
}

terraform {
  required_version = "< 0.12.0"
}

resource "aws_s3_bucket" "insecure_bucket" {
  bucket = "insecure-bucket"
  acl    = "public"
}