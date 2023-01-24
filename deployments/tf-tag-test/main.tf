terraform {
  backend "s3" {}
}

provider "aws" {
  region = var.aws_region
  default_tags {
		tags = module.git_tags.tags
	}
}

module "git_tags" {
	source = "../../modules/ai-git-tagger"
}

resource "aws_s3_bucket" "test-bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "thisara-test-bucket"
    Environment = "peng"
    wd-finops-metadata = "adaptiveplanning_nonprod_misc"
  }
}
resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.test-bucket.id
  acl    = "private"
}