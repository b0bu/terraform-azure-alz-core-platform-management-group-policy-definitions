output "deployed_definitions" {
    value = [
       for policy in azurerm_policy_definition.policy : 
        {
            name: policy.name
            id: policy.id
        }
    ]
}