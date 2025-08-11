variable "subscription_id" {
  type        = string
  description = "Target Azure Subscription ID where policies will be assigned."
}

variable "allowed_locations" {
  type        = list(string)
  description = "List of allowed Azure regions for resource deployment."
  default     = ["Central India", "East US", "West Europe"]
}

variable "required_tags" {
  type        = list(string)
  description = "List of required tag keys on resources."
  default     = ["Purpose", "Owner", "Created", "Build", "Environment", "CostCenter"]
}

variable "policy_assignment_location" {
  type        = string
  description = "Azure location where policy assignments are created."
  default     = "Central India"
}
