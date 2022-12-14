resource "azurerm_policy_definition" "policy" {

  # Mandatory resource attributes
  name         = var.name
  policy_type  = "Custom"
  mode         = var.mode
  display_name = var.display_name

  # Optional resource attributes
  description         = var.description
  management_group_id = var.management_group_id
  policy_rule         = var.policy_rule
  metadata            = var.metadata
  parameters          = var.parameters
}