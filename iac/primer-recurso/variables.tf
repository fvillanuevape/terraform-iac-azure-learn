variable "azurerm_resource_group" {
    type = string
    description = "Nombre del resource group a crear"
}

variable "azure_location" {
  type = string
  default = "eastus2"
  description = "Región disponible de Azure y donde se creará los recursos."
}

variable "azure_vm_name" {
  type = string
  description = "Nombre de la Virtual Machine."
}

variable "azure_vm_size" {
  type = string
  description = "Size de de la Azure Virtual Machine"
}