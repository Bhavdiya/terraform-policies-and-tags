terraform {
  backend "azurerm" {
    resource_group_name   = "rg-terraform"
    storage_account_name  = "ststatefileiaac"
    container_name        = "resourcestatescommon"
    key                   = "mg-non-prod.tfstate"
  }
} 