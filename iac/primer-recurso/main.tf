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

# Primer resource group
resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform-learn-dev"
  location = "eastus2"
  tags = {
    "ambiente" = "dev"
  }
}