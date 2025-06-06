terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.11.0"
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
