# Se define el provider de Azure Cloud
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.azurerm_resource_group
  location = var.azure_location
  tags = {
    "ambiente" = "dev"
  }
}
resource "azurerm_storage_account" "storage_account" {

  for_each = var.storage_accounts

  name                     = "azsa${each.value}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "ZRS"

  tags = {
    environment = "staging"
  }
}