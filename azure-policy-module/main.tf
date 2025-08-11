terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"  # specify appropriate azurerm provider version
    }
  }
}

provider "azurerm" {
  features {}
  # You can comit subscription_id here; the module provider handles that.
}

module "organization_policies" {
  source = "./azure_policy_module"

  subscription_id            = "subscription id "  # Replace with your Azure subscription ID
  allowed_locations          = ["Central India", "East US", "West Europe"]  # Override if needed
  required_tags              = ["Purpose", "Owner", "Created", "Build", "Environment", "CostCenter"]  # Override if needed
  policy_assignment_location = "Central India"  # Location for assignments
}
