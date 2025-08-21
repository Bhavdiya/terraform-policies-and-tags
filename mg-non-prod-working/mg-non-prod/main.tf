
# Built-in Policy Definitions (using data sources)
data "azurerm_policy_definition" "allowed_locations" {
  display_name = "Allowed locations"
}

data "azurerm_policy_definition" "require_tag_on_resources" {
  display_name = "Require a tag on resources"
}


data "azurerm_policy_definition" "audit_resource_location" {
  display_name = "Audit resource location matches resource group location"
}

data "azurerm_policy_definition" "boot_diagnostics" {
  display_name = "Boot Diagnostics should be enabled on virtual machines"
}

data "azurerm_policy_definition" "activity_log_retention" {
  display_name = "Activity log should be retained for at least one year"
}

data "azurerm_policy_definition" "deploy_diag_nsg" {
  display_name = "Deploy Diagnostic Settings for Network Security Groups"
}

data "azurerm_policy_definition" "azure_backup_vm" {
  display_name = "Azure Backup should be enabled for Virtual Machines"
}

data "azurerm_policy_definition" "mfa_delete" {
  display_name = "Users must authenticate with multi-factor authentication to delete resources"
}

data "azurerm_policy_definition" "remove_guest_owner" {
  display_name = "Guest accounts with owner permissions on Azure resources should be removed"
}

data "azurerm_policy_definition" "email_notification_high_alerts" {
  display_name = "Email notification to subscription owner for high severity alerts should be enabled"
}

data "azurerm_policy_definition" "kv_soft_delete" {
  display_name = "Key vaults should have soft delete enabled"
}

data "azurerm_policy_definition" "key_rotation" {
  display_name = "Keys should have a rotation policy ensuring that their rotation is scheduled within the specified number of days after creation"
}

data "azurerm_policy_definition" "managed_hsm_purge_protection" {
  display_name = "Azure Key Vault Managed HSM should have purge protection enabled"
}

data "azurerm_policy_definition" "disable_ip_forwarding" {
  display_name = "Network interfaces should disable IP forwarding"
}

data "azurerm_policy_definition" "disable_public_network_storage" {
  display_name = "Configure storage accounts to disable public network access"
}

data "azurerm_policy_definition" "ddos_protection_enabled" {
  display_name = "Azure DDoS Protection should be enabled"
}

# Custom Policy Definition for Multiple Required Tags
resource "azurerm_policy_definition" "required_multiple_tags" {
  name                = "RequireMultipleTags"
  management_group_id = data.azurerm_management_group.nonprod.id
  mode                = "All"
  
  display_name = "Require Multiple Specific Tags"
  description  = "Enforces that all resources have the required tags: Purpose, Owner, Build, Environment, Data, CrownJewel, BIA, and Created"
  
  policy_type = "Custom"
  
  metadata = jsonencode({
    "version" = "1.0.0"
    "category" = "Tags"
  })
  
  parameters = jsonencode({
    "purposeTag" = {
      "type" = "String"
      "metadata" = {
        "displayName" = "Purpose Tag Name"
        "description" = "Name of the Purpose tag"
      }
      "defaultValue" = "Purpose"
    },
    "ownerTag" = {
      "type" = "String"
      "metadata" = {
        "displayName" = "Owner Tag Name"
        "description" = "Name of the Owner tag"
      }
      "defaultValue" = "Owner"
    },
    "buildTag" = {
      "type" = "String"
      "metadata" = {
        "displayName" = "Build Tag Name"
        "description" = "Name of the Build tag"
      }
      "defaultValue" = "Build"
    },
    "environmentTag" = {
      "type" = "String"
      "metadata" = {
        "displayName" = "Environment Tag Name"
        "description" = "Name of the Environment tag"
      }
      "defaultValue" = "Environment"
    },
    "dataTag" = {
      "type" = "String"
      "metadata" = {
        "displayName" = "Data Tag Name"
        "description" = "Name of the Data tag"
      }
      "defaultValue" = "Data"
    },
    "crownJewelTag" = {
      "type" = "String"
      "metadata" = {
        "displayName" = "CrownJewel Tag Name"
        "description" = "Name of the CrownJewel tag"
      }
      "defaultValue" = "CrownJewel"
    },
    "biaTag" = {
      "type" = "String"
      "metadata" = {
        "displayName" = "BIA Tag Name"
        "description" = "Name of the BIA tag"
      }
      "defaultValue" = "BIA"
    },
    "createdTag" = {
      "type" = "String"
      "metadata" = {
        "displayName" = "Created Tag Name"
        "description" = "Name of the Created tag"
      }
      "defaultValue" = "Created"
    }
  })
  
  policy_rule = jsonencode({
    "if" = {
      "not" = {
        "allOf" = [
          {
            "field" = "[concat('tags[', parameters('purposeTag'), ']')]",
            "exists" = true
          },
          {
            "field" = "[concat('tags[', parameters('ownerTag'), ']')]",
            "exists" = true
          },
          {
            "field" = "[concat('tags[', parameters('buildTag'), ']')]",
            "exists" = true
          },
          {
            "field" = "[concat('tags[', parameters('environmentTag'), ']')]",
            "exists" = true
          },
          {
            "field" = "[concat('tags[', parameters('dataTag'), ']')]",
            "exists" = true
          },
          {
            "field" = "[concat('tags[', parameters('crownJewelTag'), ']')]",
            "exists" = true
          },
          {
            "field" = "[concat('tags[', parameters('biaTag'), ']')]",
            "exists" = true
          },
          {
            "field" = "[concat('tags[', parameters('createdTag'), ']')]",
            "exists" = true
          }
        ]
      }
    },
    "then" = {
      "effect" = "deny"
    }
  })
}

# Display names can contain spaces but IDs cannot
data "azurerm_management_group" "nonprod" {
  name = "cb7d2db3-c5fe-4b6b-903c-f723aeb3ed92"  # Use the actual management group ID
}

# Management Group Policy Assignments
resource "azurerm_management_group_policy_assignment" "allowed_locations" {
  name                 = "Allowed-Locations-UAE"
  management_group_id  = data.azurerm_management_group.nonprod.id
  policy_definition_id = data.azurerm_policy_definition.allowed_locations.id
  display_name         = "Allowed locations - UAE North"
  description          = "Restricts resource creation to UAE North region only"
  
  parameters = jsonencode({
    "listOfAllowedLocations" = {
      "value" = var.allowed_locations
    }
  })
}

resource "azurerm_management_group_policy_assignment" "required_multiple_tags" {
  name                 = "Require-Multiple-Tags"
  management_group_id  = data.azurerm_management_group.nonprod.id
  policy_definition_id = azurerm_policy_definition.required_multiple_tags.id
  display_name         = "Require Multiple Specific Tags"
  description          = "Enforces all required tags on all resources"
  
  parameters = jsonencode({
    "purposeTag" = {
      "value" = "Purpose"
    },
    "ownerTag" = {
      "value" = "Owner"
    },
    "buildTag" = {
      "value" = "Build"
    },
    "environmentTag" = {
      "value" = "Environment"
    },
    "dataTag" = {
      "value" = "Data"
    },
    "crownJewelTag" = {
      "value" = "CrownJewel"
    },
    "biaTag" = {
      "value" = "BIA"
    },
    "createdTag" = {
      "value" = "Created"
    }
  })
}

// Example: Require a tag on resources
resource "azurerm_policy_assignment" "require_tag_on_resources" {
  name                 = "require-tag-on-resources"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/RequireTagOnResources"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
  description          = "Require a tag on resources"
  enforce              = true
}

// Example: Allowed Locations
resource "azurerm_policy_assignment" "allowed_locations" {
  name                 = "allowed-locations"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/AllowedLocations"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
  description          = "Allowed Locations"
  enforce              = true
  // Optional: parameters if needed
  parameters           = <<PARAMS
{
  "listOfAllowedLocations": {
    "value": ["CentralIndia", "WestIndia"]
  }
}
PARAMS
}

// Example: Audit resource location matches resource group location
resource "azurerm_policy_assignment" "audit_resource_location" {
  name                 = "audit-resource-location"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/AuditResourceLocationMatchesResourceGroupLocation"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
  description          = "Audit resource location matches resource group location"
}

# Repeat similarly for other policies,
resource "azurerm_policy_assignment" "boot_diagnostics" {
  name                 = "boot-diagnostics"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/fb97d6e1-5c98-4743-a439-23e0977bad9e"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
  description          = "Boot Diagnostics should be enabled on virtual machines"
  enforce              = true
}

resource "azurerm_policy_assignment" "activity_log_retention" {
  name                 = "activity-log-retention"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/b02aacc0-b073-424e-8298-42b22829ee0a"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
  description          = "Activity log should be retained for at least one year"
  enforce              = true
}

resource "azurerm_policy_assignment" "deploy_diag_nsg" {
  name                 = "deploy-diagnostic-nsg"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/c9c29499-c1d1-4195-99bd-2ec9e3a9dc89"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
  description          = "Deploy Diagnostic Settings for Network Security Groups"
  enforce              = true
}

resource "azurerm_policy_assignment" "azure_backup_vm" {
  name                 = "azure-backup-vm"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/dd450d96-0fa4-4395-9430-3a8060aa7ba7"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
  description          = "Azure Backup should be enabled for Virtual Machines"
  enforce              = true
}

resource "azurerm_policy_assignment" "mfa_delete" {
  name                 = "mfa-delete"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/4e6c27d5-a6ee-49cf-b2b4-d8fe90fa2b8b"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
  description          = "Users must authenticate with multi-factor authentication to delete resources"
  enforce              = true
}

resource "azurerm_policy_assignment" "remove_guest_owner" {
  name                 = "remove-guest-owner"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/339353f6-2387-4a45-abe4-7f529d121046"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
  description          = "Guest accounts with owner permissions on Azure resources should be removed"
  enforce              = true
}

resource "azurerm_policy_assignment" "email_notification_high_alerts" {
  name                 = "email-notification-high-alerts"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/0b15565f-aa9e-48ba-8619-45960f2c314d"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
  description          = "Email notification to subscription owner for high severity alerts should be enabled"
  enforce              = true
}

resource "azurerm_policy_assignment" "kv_soft_delete" {
  name                 = "kv-soft-delete"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1e66c121-a66a-4b1f-9b83-0fd99bf0fc2d"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
  description          = "Key vaults should have soft delete enabled"
  enforce              = true
}

resource "azurerm_policy_assignment" "key_rotation" {
  name                 = "key-rotation"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/d8cf8476-a2ec-4916-896e-992351803c44"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
  description          = "Keys should have a rotation policy ensuring that their rotation is scheduled within the specified number of days after creation"
  enforce              = true
}

resource "azurerm_policy_assignment" "managed_hsm_purge_protection" {
  name                 = "managed-hsm-purge-protection"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/c39ba22d-4428-4149-b981-70acb31fc383"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
  description          = "Azure Key Vault Managed HSM should have purge protection enabled"
  enforce              = true
}

resource "azurerm_policy_assignment" "disable_ip_forwarding" {
  name                 = "disable-ip-forwarding"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/88c0b9da-ce96-4b03-9635-f29a937e2900"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
  description          = "Network interfaces should disable IP forwarding"
  enforce              = true
}

resource "azurerm_policy_assignment" "disable_public_network_storage" {
  name                 = "disable-public-network-storage"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a06d0189-92e8-4dba-b0c4-08d7669fce7d"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
  description          = "Configure storage accounts to disable public network access"
  enforce              = true
}

resource "azurerm_policy_assignment" "ddos_protection_enabled" {
  name                 = "ddos-protection-enabled"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a7aca53f-2ed4-4466-a25e-0b45ade68efd"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
  description          = "Azure DDoS Protection should be enabled"
  enforce              = true
}
