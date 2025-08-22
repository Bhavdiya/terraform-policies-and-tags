# --------------------------
# Data sources
# --------------------------
data "azurerm_management_group" "nonprod" {
  name = "nonprod"
}

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

# --------------------------
# Custom Policy: Require Multiple Tags
# --------------------------
resource "azurerm_policy_definition" "required_multiple_tags" {
  name                = "RequireMultipleTags"
  management_group_id = data.azurerm_management_group.nonprod.id
  mode                = "All"

  display_name = "Require Multiple Specific Tags"
  description  = "Enforces that all resources have the required tags: Purpose, Owner, Build, Environment, Data, CrownJewel, BIA, and Created"
  policy_type  = "Custom"

  metadata = jsonencode({
    "version"  = "1.0.0"
    "category" = "Tags"
  })

  parameters = jsonencode({
    "purposeTag"     = { "type" = "String", "defaultValue" = "Purpose" }
    "ownerTag"       = { "type" = "String", "defaultValue" = "Owner" }
    "buildTag"       = { "type" = "String", "defaultValue" = "Build" }
    "environmentTag" = { "type" = "String", "defaultValue" = "Environment" }
    "dataTag"        = { "type" = "String", "defaultValue" = "Data" }
    "crownJewelTag"  = { "type" = "String", "defaultValue" = "CrownJewel" }
    "biaTag"         = { "type" = "String", "defaultValue" = "BIA" }
    "createdTag"     = { "type" = "String", "defaultValue" = "Created" }
  })

  policy_rule = jsonencode({
    "if" = {
      "not" = {
        "allOf" = [
          { "field" = "[concat('tags[', parameters('purposeTag'), ']')]", "exists" = true },
          { "field" = "[concat('tags[', parameters('ownerTag'), ']')]", "exists" = true },
          { "field" = "[concat('tags[', parameters('buildTag'), ']')]", "exists" = true },
          { "field" = "[concat('tags[', parameters('environmentTag'), ']')]", "exists" = true },
          { "field" = "[concat('tags[', parameters('dataTag'), ']')]", "exists" = true },
          { "field" = "[concat('tags[', parameters('crownJewelTag'), ']')]", "exists" = true },
          { "field" = "[concat('tags[', parameters('biaTag'), ']')]", "exists" = true },
          { "field" = "[concat('tags[', parameters('createdTag'), ']')]", "exists" = true }
        ]
      }
    },
    "then" = { "effect" = "deny" }
  })
}

# --------------------------
# Policy Assignments
# --------------------------

# Allowed Locations
resource "azurerm_management_group_policy_assignment" "allowed_locations" {
  name                 = "allowed-locations"
  management_group_id  = data.azurerm_management_group.nonprod.id
  policy_definition_id = data.azurerm_policy_definition.allowed_locations.id
  description          = "Restricts resource creation to specific regions"
  parameters = jsonencode({
    "listOfAllowedLocations" = { "value" = var.allowed_locations }
  })
}

# Require Multiple Tags
resource "azurerm_management_group_policy_assignment" "required_multiple_tags" {
  name                 = "require-multiple-tags"
  management_group_id  = data.azurerm_management_group.nonprod.id
  policy_definition_id = azurerm_policy_definition.required_multiple_tags.id
  description          = "Enforces all required tags on resources"
}

# Require a tag on resources
resource "azurerm_policy_assignment" "require_tag_on_resources" {
  name                 = "require-tag-on-resources"
  policy_definition_id = data.azurerm_policy_definition.require_tag_on_resources.id
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
  description          = "Require a tag on resources"
}

# Audit resource location matches resource group location
resource "azurerm_policy_assignment" "audit_resource_location" {
  name                 = "audit-resource-location"
  policy_definition_id = data.azurerm_policy_definition.audit_resource_location.id
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
}

# Boot Diagnostics
resource "azurerm_policy_assignment" "boot_diagnostics" {
  name                 = "boot-diagnostics"
  policy_definition_id = data.azurerm_policy_definition.boot_diagnostics.id
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
}

# --------------------------
# Missing Policies from Table
# --------------------------

# Activity log retention
resource "azurerm_policy_assignment" "activity_log_retention" {
  name                 = "activity-log-retention"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a451c1ef-c6ca-483d-87ed-f49761e3ffb5"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
}

# Deploy Diagnostic Settings for NSG
resource "azurerm_policy_assignment" "deploy_nsg_diagnostics" {
  name                 = "deploy-nsg-diagnostics"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/deployDiagnosticSettingsForNetworkSecurityGroups"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
}

# Azure Backup for VM
resource "azurerm_policy_assignment" "azure_backup_vm" {
  name                 = "azure-backup-vm"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/azureBackupForVMs"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
}

# MFA for Delete
resource "azurerm_policy_assignment" "mfa_delete" {
  name                 = "mfa-delete"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/mfaForDeleteResources"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
}

# Remove Guest Owner Accounts
resource "azurerm_policy_assignment" "guest_owner_accounts" {
  name                 = "guest-owner-accounts"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/removeGuestOwnerAccounts"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
}

# Email High Severity Alerts
resource "azurerm_policy_assignment" "email_high_alerts" {
  name                 = "email-high-alerts"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/emailHighSeverityAlerts"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
}

# Key Vault Soft Delete
resource "azurerm_policy_assignment" "kv_soft_delete" {
  name                 = "kv-soft-delete"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/keyVaultSoftDelete"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
}

# Key Vault Key Rotation
resource "azurerm_policy_assignment" "kv_key_rotation" {
  name                 = "kv-key-rotation"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/keyVaultKeyRotation"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
}

# HSM Purge Protection
resource "azurerm_policy_assignment" "kv_hsm_purge_protection" {
  name                 = "kv-hsm-purge-protection"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/keyVaultHsmPurgeProtection"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
}

# Disable IP Forwarding
resource "azurerm_policy_assignment" "nic_disable_ip_forwarding" {
  name                 = "nic-disable-ip-forwarding"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/disableIPForwarding"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
}

# Storage Disable Public Access
resource "azurerm_policy_assignment" "storage_disable_public_access" {
  name                 = "storage-disable-public-access"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/storageDisablePublicNetworkAccess"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
}

# DDoS Protection
resource "azurerm_policy_assignment" "ddos_protection" {
  name                 = "ddos-protection"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/ddosProtectionEnabled"
  scope                = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
}
