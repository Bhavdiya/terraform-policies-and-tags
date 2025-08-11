provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

data "azurerm_subscription" "current" {
  subscription_id = var.subscription_id
}

resource "azurerm_policy_definition" "allowed_locations" {
  name         = "allowed-locations"
  policy_type  = "Custom"
  mode         = "All"

  display_name = "Allowed locations"
  description  = "Restrict allowed Azure regions for resource deployment."

  policy_rule = jsonencode({
    if = {
      not = {
        field = "location"
        in    = var.allowed_locations
      }
    }
    then = {
      effect = "deny"
    }
  })
}

resource "azurerm_policy_definition" "require_tags" {
  name         = "require-tags-on-resources"
  policy_type  = "Custom"
  mode         = "All"

  display_name = "Require specific tags on resources"
  description  = "Resources must have tags: ${join(", ", var.required_tags)}."

  policy_rule = jsonencode({
    if = {
      not = {
        allOf = [
          for tag in var.required_tags : {
            field  = "tags['${tag}']"
            exists = "true"
          }
        ]
      }
    }
    then = {
      effect = "deny"
    }
  })
}

resource "azurerm_policy_set_definition" "organization_policy_set" {
  name         = "organization-policy-set"
  policy_type  = "Custom"
  display_name = "Organization Policy Set for Region and Tagging"
  description  = "A policy set combining allowed locations and required tags policies."

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.allowed_locations.id
  }

  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.require_tags.id
  }
}

resource "azurerm_subscription_policy_assignment" "assign_policy_set" {
  name                 = "assign-organization-policy-set"
  policy_definition_id = azurerm_policy_set_definition.organization_policy_set.id
  subscription_id = data.azurerm_subscription.current.id
  location             = var.policy_assignment_location
}
