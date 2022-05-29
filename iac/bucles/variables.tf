variable "azurerm_resource_group" {
    type = string
    description = "Nombre del resource group a crear"
}

variable "azure_location" {
  type = string
  default = "eastus2"
  description = "Región disponible de Azure y donde se creará los recursos."
}

variable "storage_accounts" {
  description = "Nombre de Storage Accounts"
  type = set(string)
}