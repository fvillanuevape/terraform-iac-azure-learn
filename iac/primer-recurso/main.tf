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
  name     = var.azure_vm_size
  location = var.azure_location
  tags = {
    "ambiente" = "dev"
  }
}


# Se crea un Network Security Group en Azure
# Se añade dos reglas para el puerto 80 y 22
resource "azurerm_network_security_group" "nsg" {
  name                = "ansg-websubnet-dev-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
 security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
   security_rule {
    name                       = "HTTP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = azurerm_resource_group.rg.tags
}

# 1°: Crear una Azure Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-appcore-dev-01"
  address_space       = ["10.70.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags = azurerm_resource_group.rg.tags
}

# 2°: Crear una Subnet
resource "azurerm_subnet" "vnet_subnet" {
  name                 = "web-subnet-01"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.70.1.0/24"]
  
}

# Crear una IP Publica para la VM
resource "azurerm_public_ip" "pip" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
  name                = "vmweb-nic-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.vnet_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
  tags = azurerm_resource_group.rg.tags
}

# Asociar el Network Security Group a la NIC de la VM
resource "azurerm_network_interface_security_group_association" "nsg_nic" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Crear un SSH Key para conectarse al servidor
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Crear una Virtual Machine
# Sistema Operativo Linux (Ubuntu)
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "azvmwebdev01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.ssh_key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  tags = azurerm_resource_group.rg.tags
}