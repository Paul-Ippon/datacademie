provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket  = "datacademie-ippon-tfstate"
    key     = "airflow/infra.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}



