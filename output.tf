output "deployed_definition" {
    value = {
            name: azurerm_policy_definition.policy.name
            id: azurerm_policy_definition.policy.id
        }
}