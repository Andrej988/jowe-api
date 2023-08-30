terraform {
  cloud {
    organization = "initialised-si"
    workspaces {
      name = "JoWe-API-Dev"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.3.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.4.0"
    }
  }
  required_version = ">= 1.2.0"
}
