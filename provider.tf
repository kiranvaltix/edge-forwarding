terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    valtix = {
      source = "valtix-security/valtix"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = var.aws_creds_profile
}

provider "valtix" {
  api_key_file = file(var.valtix_api_key)
}
