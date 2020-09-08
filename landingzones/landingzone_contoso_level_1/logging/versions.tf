terraform {
  required_providers {
    azurecaf = {
      source = "aztfmod/azurecaf"
      version = "1.0.0-pre"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
  required_version = ">= 0.13"
}
