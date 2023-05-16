terraform {
  cloud {
    organization = "initialised-si"

    workspaces {
      name = "JoWe-API"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.67.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.3.0"
    }
  }
  required_version = ">= 1.0"
}
