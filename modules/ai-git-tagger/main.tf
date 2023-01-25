terraform {
  required_providers {
    external = {
      source  = "hashicorp/external"
      version = ">= 2.0.0"
    }
  }
}

data "external" "git" {
  program = ["bash", "${path.module}/gitinfo.sh"]
  query = {}
}

data "external" "git_minimal" {
  program = ["bash", "${path.module}/gitinfo.sh", "minimal"]
  query = {}
}
