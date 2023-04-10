terraform {
  #cloud {
  #  organization = ""

  #  workspaces {
  #    name = ""
  #  }
  #}
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.62.0"
    }
    archive = {
      source = "hashicorp/archive"
      version = "~> 2.3.0"
    }
  }
  required_version = "~> 1.0"
}
