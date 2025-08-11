variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "allowed_locations" {
  type    = list(string)
  default = ["Central India", "East US", "West Europe"]
}

variable "required_tags" {
  type    = list(string)
  default = ["Purpose", "Owner", "Created", "Build", "Environment", "CostCenter"]
}

variable "policy_assignment_location" {
  type    = string
  default = "Central India"
}
