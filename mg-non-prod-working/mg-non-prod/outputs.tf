# Policy Module Outputs

# Management Group Policy Assignment IDs
output "allowed_locations_assignment_id" {
  description = "ID of the allowed locations policy assignment"
  value       = azurerm_management_group_policy_assignment.allowed_locations.id
}

output "required_multiple_tags_assignment_id" {
  description = "ID of the required multiple tags policy assignment"
  value       = azurerm_management_group_policy_assignment.required_multiple_tags.id
}

# Built-in Policy Definition IDs
output "allowed_locations_policy_id" {
  description = "ID of the allowed locations built-in policy definition"
  value       = data.azurerm_policy_definition.allowed_locations.id
}

# Custom Policy Definition ID
output "required_multiple_tags_policy_id" {
  description = "ID of the custom required multiple tags policy definition"
  value       = azurerm_policy_definition.required_multiple_tags.id
}

# Summary outputs
output "management_group_assignments" {
  description = "Map of management group policy assignment IDs"
  value = {
    allowed_locations = azurerm_management_group_policy_assignment.allowed_locations.id
    required_multiple_tags = azurerm_management_group_policy_assignment.required_multiple_tags.id
  }
}

output "enabled_policies" {
  description = "List of enabled policy names"
  value = [
    "Allowed locations - UAE North",
    "Require Multiple Specific Tags"
  ]
}

output "policy_scope_info" {
  description = "Information about policy scopes and exclusions"
  value = {
    management_group_id = data.azurerm_management_group.nonprod.id
    management_group_name = data.azurerm_management_group.nonprod.name
    allowed_locations = var.allowed_locations
  }
}
