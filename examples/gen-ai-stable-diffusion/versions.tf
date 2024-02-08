terraform {
  required_version = ">=1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.31"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = ">=2.2.0"
    }
  }
}