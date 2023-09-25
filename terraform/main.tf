provider "aws" {
  region = "eu-west-1"
}

terraform {

  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket  = "datacademie-ippon-tfstate"
    key     = "datacademie-ippon-tfstate.tfstate"
    region  = "eu-west-1"
    encrypt = true
  }
}

## Data to get your personal IP address
data "external" "whatismyip" {
  program = ["/usr/bin/bash" , "./ressources/whatismyip.sh"]
}

module "airbyte" {
  source = "./modules/airbyte"

  project = var.project
  name = var.name
  ip = data.external.whatismyip.result["internet_ip"]
}

module "superset" {
  source = "./modules/superset"

  project = var.project
  name = var.name
  ip = data.external.whatismyip.result["internet_ip"]
}


