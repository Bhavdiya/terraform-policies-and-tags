# Variables
variable "allowed_locations" {
  description = "Allowed locations for resources"
  type        = list(string)
  default     = ["UAE North"]
}

# Management Group ID (required for scoping policy assignments)
variable "management_group_id" {
  description = "Target Management Group ID where policies will be assigned"
  type        = string
  default     = "cb7d2db3-c5fe-4b6b-903c-f723aeb3ed92" # Replace with your actual MG ID if different
}

#variable "required_tags" {
#  description = "Required tags for resources"
#  type        = map(string)
#  default = {
#    Environment = "Production"
#    Project     = "Azure Policies"
#    Owner       = "Operations Team"
#    CostCenter  = "IT-002"
#    Compliance  = "SOC2"
#  }
#}

