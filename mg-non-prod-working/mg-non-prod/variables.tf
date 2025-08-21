# Variables
variable "allowed_locations" {
  description = "Allowed locations for resources"
  type        = list(string)
  default     = ["UAE North"]
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

