output "policy_assignments" {
  description = "Map of all policy assignment IDs"
  value = {
    allowed_locations          = azurerm_management_group_policy_assignment.allowed_locations.id
    required_multiple_tags     = azurerm_management_group_policy_assignment.required_multiple_tags.id
    require_tag_on_resources   = azurerm_policy_assignment.require_tag_on_resources.id
    audit_resource_location    = azurerm_policy_assignment.audit_resource_location.id
    boot_diagnostics           = azurerm_policy_assignment.boot_diagnostics.id
    activity_log_retention     = azurerm_policy_assignment.activity_log_retention.id
    deploy_nsg_diagnostics     = azurerm_policy_assignment.deploy_nsg_diagnostics.id
    azure_backup_vm            = azurerm_policy_assignment.azure_backup_vm.id
    mfa_delete                 = azurerm_policy_assignment.mfa_delete.id
    guest_owner_accounts       = azurerm_policy_assignment.guest_owner_accounts.id
    email_high_alerts          = azurerm_policy_assignment.email_high_alerts.id
    kv_soft_delete             = azurerm_policy_assignment.kv_soft_delete.id
    kv_key_rotation            = azurerm_policy_assignment.kv_key_rotation.id
    kv_hsm_purge_protection    = azurerm_policy_assignment.kv_hsm_purge_protection.id
    nic_disable_ip_forwarding  = azurerm_policy_assignment.nic_disable_ip_forwarding.id
    storage_disable_public_access = azurerm_policy_assignment.storage_disable_public_access.id
    ddos_protection            = azurerm_policy_assignment.ddos_protection.id
  }
}

output "enabled_policies" {
  description = "List of enabled policy names"
  value = [
    "Allowed Locations",
    "Require Multiple Tags",
    "Require Tag on Resources",
    "Audit Resource Location",
    "Boot Diagnostics",
    "Activity Log Retention",
    "Deploy NSG Diagnostics",
    "Azure Backup VM",
    "MFA Delete Protection",
    "Remove Guest Owner Accounts",
    "Email High Severity Alerts",
    "Key Vault Soft Delete",
    "Key Vault Key Rotation",
    "HSM Purge Protection",
    "NIC Disable IP Forwarding",
    "Storage Disable Public Access",
    "DDoS Protection"
  ]
}
