terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.36.0, <=5.0.1, !=4.43.0"
      # se debe utilizar el terraform init -upgrade, para no entrar en conflicto con 
      # la version que se esté usando en tiempo real y vuelve a establecer una nueva version
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
  # quiere decir que cualquier subversion de la 1.4 puede ser utilizada
  required_version = "~>1.3.9"

}

provider "aws" {
  # Configuration options
  region = "us-east-1"
  # para el acceso a aws desde terraform cloud
  access_key = var.access_key
  secret_key = var.secret_key

  default_tags {
    tags = var.tags
  }

}
