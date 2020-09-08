provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
  }
}

terraform {
  required_version = ">= 0.13"
}

data "terraform_remote_state" "level0_launchpad" {
  backend = "azurerm"
  config = {
    storage_account_name = var.lowerlevel_storage_account_name
    container_name       = var.lowerlevel_container_name
    key                  = var.lowerlevel_key
    resource_group_name  = var.lowerlevel_resource_group_name
  }
}

data "azurerm_client_config" "current" {
}

data "azurerm_subscription" "primary" {
}

# We use this to interpolate a name we can use in the naming conventions. Everything is prefixed with "GOVERNANCE-"
data "null_data_source" "subscription_prefix" {
  inputs = {
    subscription_prefix = "GOVERNANCE-${var.global_settings.team_prefix}-${var.global_settings.environment_prefix}"
  }
}

# Data source used for interpolating the names for AAD user groups (RBAC)
data "null_data_source" "usergroups_rbac_default" {
  inputs = {
    grp_owner       = "GRP-${data.null_data_source.subscription_prefix.outputs["subscription_prefix"]}-OWNER"
    grp_contributor = "GRP-${data.null_data_source.subscription_prefix.outputs["subscription_prefix"]}-CONTRIBUTOR"
    grp_reader      = "GRP-${data.null_data_source.subscription_prefix.outputs["subscription_prefix"]}-READER"
  }
}

#########
# Locals
#########


locals {
  policy_formatted_locations = join(",", formatlist("\"%s\"", var.policy_config.allowed_locations))
}

#########
# Resources
#########

module logging {
  source              = "./logging"
  location            = var.global_settings.location
  tags                = var.global_settings.tags
  workspace_name      = "loganalytics"
  solution_plan_map   = var.logging_config.solution_plan_map
  activity_log_map    = var.logging_config.activity_log_map
  subscription_prefix = data.null_data_source.subscription_prefix.outputs["subscription_prefix"]
}

module rbac {
  source                = "./rbac"
  usergroup_owner       = data.null_data_source.usergroups_rbac_default.outputs["grp_owner"]
  usergroup_contributor = data.null_data_source.usergroups_rbac_default.outputs["grp_contributor"]
  usergroup_reader      = data.null_data_source.usergroups_rbac_default.outputs["grp_reader"]
  subscription_id       = data.azurerm_subscription.primary.id
}

module policy {
  source            = "./policy"
  scope_id          = data.azurerm_subscription.primary.id
  location          = var.global_settings.location
  allowed_locations = local.policy_formatted_locations

  enable_allowed_locations        = true
  enable_deny_public_ip_addresses = true
}
