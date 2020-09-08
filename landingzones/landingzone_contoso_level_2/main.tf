provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
  }
}

terraform {
  required_providers {
    azurecaf = {
      source = "aztfmod/azurecaf"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.25.0"
    }
  }
  required_version = ">= 0.13"
}

#data "terraform_remote_state" "level0_launchpad" {
#  backend = "azurerm"
#  config = {
#    storage_account_name = var.lowerlevel_storage_account_name
#    container_name       = var.lowerlevel_container_name
#    key                  = var.lowerlevel_key
#    resource_group_name  = var.lowerlevel_resource_group_name
#  }
#}

data "terraform_remote_state" "landingzone_contoso_level_1" {
  backend = "azurerm"
  config = {
    storage_account_name = var.lowerlevel_storage_account_name
    container_name       = "sandpit"
    key                  = "landingzone_contoso_level_1.tfstate"
    resource_group_name  = var.lowerlevel_resource_group_name
  }
}

data "azurerm_client_config" "current" {
}

data "azurerm_subscription" "primary" {
}

locals {
    log_analytics  = data.terraform_remote_state.landingzone_contoso_level_1.outputs.log_analytics
    global_settings = data.terraform_remote_state.landingzone_contoso_level_1.outputs.global_settings
    subscription_prefix = data.terraform_remote_state.landingzone_contoso_level_1.outputs.subscription_prefix
}

#Naming convention for the ACR
resource "azurecaf_naming_convention" "rg_acr_name" {
  name          = "acr-rg"
  prefix        = local.subscription_prefix
  resource_type = "rg"
  max_length    = 50
  convention    = "passthrough"
}

#Create a resource group for the logging components
resource "azurerm_resource_group" "rg_acr" {
  name     = azurecaf_naming_convention.rg_acr_name.result
  location = local.global_settings.location
  tags     = local.global_settings.tags
}

module acr {
  source                  = "./acr"
  resource_group_name     = azurerm_resource_group.rg_acr.name
  tags                    = local.global_settings.tags
  location                = local.global_settings.location
  replication_location    = "North Europe"
  acr_name                = "exampleAcr123"
  law_id                  = local.log_analytics.log_analytics.id
  diagnosticsName         = "acrDiagnostics"
}
