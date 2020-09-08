# Policy for specifying explicitly whitelisted Azure regions

resource "azurerm_policy_assignment" "allowed_locations" {
  count = var.enable_allowed_locations ? 1 : 0

  name                 = "LandingZone-allowed_locations"
  scope                = var.scope_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
  description          = "This policy enables you to restrict the locations your organization can specify when deploying resources. Use to enforce your geo-compliance requirements. Excludes resource groups, Microsoft.AzureActiveDirectory/b2cDirectories, and resources that use the 'global' region."
  display_name         = "Allowed locations"
  location             = var.location
  identity { type = "SystemAssigned" }

  parameters = <<PARAMETERS
    {
    "listOfAllowedLocations": {
      "value": [ ${var.allowed_locations} ]
    }
    }
  PARAMETERS
}

resource "azurerm_policy_assignment" "deny_public_ip_addresses" {
  count = var.enable_deny_public_ip_addresses ? 1 : 0

  name                 = "LandingZone-deny-public-ip-addresses"
  scope                = var.scope_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/83a86a26-fd1f-447c-b59d-e51f44264114"
  description          = "Network interfaces should not have public IPs https://portal.azure.com/#blade/Microsoft_Azure_Policy/PolicyDetailBlade/definitionId/%2Fproviders%2FMicrosoft.Authorization%2FpolicyDefinitions%2F83a86a26-fd1f-447c-b59d-e51f44264114"
  display_name         = "Deny Public IP address objects"
}