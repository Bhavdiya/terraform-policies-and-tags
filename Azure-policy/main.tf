provider "azurerm" {
  features {}
  subscription_id = "sub id"  # Replace with your actual Azure subscription ID
}

# Get the current subscription
data "azurerm_subscription" "current" {}

# Allowed locations policy
resource "azurerm_policy_definition" "allowed_locations" {
  name         = "allowed-locations"
  policy_type  = "Custom"
  mode         = "All"

  display_name = "Allowed locations"
  description  = "Restrict allowed Azure regions for resource deployment."

  policy_rule = <<POLICY_RULE
{
  "if": {
    "not": {
      "field": "location",
      "in": ["Central India", "East US", "West Europe"]
    }
  },
  "then": {
    "effect": "deny"
  }
}
POLICY_RULE
}

# Required tags policy
resource "azurerm_policy_definition" "require_tags" {
  name         = "require-tags-on-resources"
  policy_type  = "Custom"
  mode         = "All"

  display_name = "Require specific tags on resources"
  description  = "Resources must have tags: Purpose, Owner, Created, Build, Environment, CostCenter."

  policy_rule = <<POLICY_RULE
{
  "if": {
    "not": {
      "allOf": [
        { "field": "tags['Purpose']",      "exists": "true" },
        { "field": "tags['Owner']",        "exists": "true" },
        { "field": "tags['Created']",      "exists": "true" },
        { "field": "tags['Build']",        "exists": "true" },
        { "field": "tags['Environment']",  "exists": "true" },
        { "field": "tags['CostCenter']",   "exists": "true" }
      ]
    }
  },
  "then": {
    "effect": "deny"
  }
}
POLICY_RULE
}

# Create a Policy Set Definition (Initiative) to group and validate the policies
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

# Assign the Policy Set (Initiative) to the subscription
resource "azurerm_subscription_policy_assignment" "assign_policy_set" {
  name                 = "assign-organization-policy-set"
  policy_definition_id = azurerm_policy_set_definition.organization_policy_set.id
  subscription_id      = data.azurerm_subscription.current.id
  location             = "Central India"
}
