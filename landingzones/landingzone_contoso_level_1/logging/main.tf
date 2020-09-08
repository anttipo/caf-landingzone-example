#Naming convention for the logging components
resource "azurecaf_naming_convention" "rg_logging_name" {
  name          = "logging-rg"
  prefix        = var.subscription_prefix
  resource_type = "rg"
  max_length    = 50
  convention    = "passthrough"
}

#Create a resource group for the logging components
resource "azurerm_resource_group" "rg_logging" {
  name     = azurecaf_naming_convention.rg_logging_name.result
  location = var.location
  tags     = var.tags
}

#Create the Log Analytics workspace
module "log_analytics" {
  source  = "aztfmod/caf-log-analytics/azurerm"
  version = "2.3.0"

  location            = var.location
  tags                = var.tags
  resource_group_name = azurerm_resource_group.rg_logging.name

  name              = var.workspace_name
  convention        = "cafrandom"
  prefix            = var.subscription_prefix
  solution_plan_map = var.solution_plan_map
}

module "activity_logs" {
  source  = "aztfmod/caf-activity-logs/azurerm"
  version = "3.1.0"

  location            = var.location
  tags                = var.tags
  resource_group_name = azurerm_resource_group.rg_logging.name


  name                       = "activityLogAudit"
  convention                 = "cafclassic"
  diagnostic_name            = "activityLogAudit"
  log_analytics_workspace_id = module.log_analytics.id
  prefix                     = var.subscription_prefix
  audit_settings_object      = var.activity_log_map
  enable_event_hub           = false
}