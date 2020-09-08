# Default role groups that are created for every onboarded subscription (owner, contributor and reader)
# This could in theory be looped with for each and provide a list of groups but we want
# to remain strict that we create three individual groups, each dedicated for a single role.
# This keeps the pattern simple.

# Owner RBAC group and the assignment
resource "azuread_group" "usergroup_owner" {
    name = var.usergroup_owner
}

resource "azurerm_role_assignment" "assignment_rbac_owner" {
    scope                   = var.subscription_id
    role_definition_name    = "Owner"
    principal_id            = azuread_group.usergroup_owner.id
}

# Contributor RBAC group and the assignment
resource "azuread_group" "usergroup_contributor" {
    name = var.usergroup_contributor
}

resource "azurerm_role_assignment" "assignment_rbac_contributor" {
    scope                   = var.subscription_id
    role_definition_name    = "Contributor"
    principal_id            = azuread_group.usergroup_contributor.id
}

# Reader RBAC group and the assignment
resource "azuread_group" "usergroup_reader" {
    name = var.usergroup_reader
}

resource "azurerm_role_assignment" "assignment_rbac_reader" {
    scope                   = var.subscription_id
    role_definition_name    = "Reader"
    principal_id            = azuread_group.usergroup_reader.id
}