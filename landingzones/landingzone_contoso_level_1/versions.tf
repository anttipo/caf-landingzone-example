terraform {
  required_version = ">= 0.13"
  required_providers {
    azurecaf = {
      source = "aztfmod/azurecaf"
      version = "1.0.0-pre"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.25.0"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}
