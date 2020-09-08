resource "azurerm_container_registry" "acr" {
  name                     = var.acr_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  sku                      = "Premium"
  admin_enabled            = false
  georeplication_locations = [var.replication_location]
  tags                     = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "diagnostics" {
  name               = var.diagnosticsName
  target_resource_id = azurerm_container_registry.acr.id
  log_analytics_workspace_id = var.law_id
  log_analytics_destination_type = "Dedicated"

  log {
    category = "ContainerRegistryRepositoryEvents"
    enabled  = true
  }

  log {
    category = "ContainerRegistryLoginEvents"
    enabled  = true
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
    }
  }
}
