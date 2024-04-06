terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.43.0"
    }
    #    tls = {
    #      source  = "hashicorp/tls"
    #      version = "~> 4.0.4"
    #    }
    #    random = {
    #      source  = "hashicorp/random"
    #      version = "~> 3.5.1"
    #    }
    #    local = {
    #      source  = "hashicorp/local"
    #      version = "~> 2.4.0"
    #    }
    #    archive = {
    #      source  = "hashicorp/archive"
    #      version = "~> 2.4.0"
    #    }
  }
}

provider "aws" {
  region = "us-east-1"
}
