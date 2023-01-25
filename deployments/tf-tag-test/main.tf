terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "test-bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "thisara-test-bucket"
    Environment = "peng"
    wd-finops-metadata = "test_tag"
  }
}
resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.test-bucket.id
  acl    = "private"
}