locals {
  // the value assigned to the tf output
  // can this be simplified, i.e. no specific requires_id or
  // output = azurerm_policy_set_definition.policy

  // source of truth for which policy requires an identity and which role should be assigned to that identity
  azurerm_role_assignments = {
    "Security Admin" = ["Deploy-MDFC-Config"],
    "Contributor" = ["Deploy-MDFC-Config"],
    "Log Analytics Contributor" = [],
    "Monitoring Contributor" = [],
    "Virtual Machine Contributor" = []
  }

  # output = {
  #   requires_identity = {
  #       for policy in local.set_definition_ids : 
  #         policy.name => policy.id
  #   }
  #   no_required_identity = {}
  # }

  templated_policy_definitions = var.policy_definitions

  set_definition_ids = azurerm_policy_definition.policy

  common_template_values = {
    scope    = var.management_group_id
    location = "uksouth"
  }
}

// needs managed identity first so needs to be assigned 
resource "azurerm_policy_definition" "policy" {
  for_each = local.templated_policy_definitions

  # Mandatory resource attributes
  name         = each.value.name
  policy_type  = "Custom"
  mode         = each.value.properties.mode
  display_name = each.value.properties.displayName

  # Optional resource attributes
  description         = try(each.value.properties.description, "${each.value.name} Policy Definition at scope ${each.value.scope_id}")
  management_group_id = try(each.value.scope_id, local.common_template_values.scope) // if scope id not set in policy use val passed to module
  policy_rule         = try(length(each.value.properties.policyRule) > 0, false) ? jsonencode(each.value.properties.policyRule) : null
  metadata            = try(length(each.value.properties.metadata) > 0, false) ? jsonencode(each.value.properties.metadata) : null
  parameters          = try(length(each.value.properties.parameters) > 0, false) ? jsonencode(each.value.properties.parameters) : null
}