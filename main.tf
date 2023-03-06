terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.45.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "46a13aec-fd6a-48b2-ad56-0edd28376832"
  tenant_id       = "54ddb93a-f40a-46d5-a6d4-34b3c5aa9974"
  client_id       = "4b52071c-69f2-495c-bb45-8733433045e8"
  client_secret   = "Qan8Q~WUAdSTrkdMPqgNaSnM1oztncg.snDcZa4-"

  features {}
}

resource "azurerm_resource_group" "flask-project" {
  name     = "flask-project"
  location = "uksouth"
}

resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create a virtual network
resource "azurerm_virtual_network" "flask-vnet2" {
  name                = "flask-vnet2"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.flask-project.location
  resource_group_name = azurerm_resource_group.flask-project.name
}

resource "azurerm_subnet" "flask-subnet" {
  name                 = "flask-subnet"
  resource_group_name  = azurerm_resource_group.flask-project.name
  virtual_network_name = azurerm_virtual_network.flask-vnet2.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "nginx-pub1" {
  name                = "nginx-pub1"
  location            = azurerm_resource_group.flask-project.location
  resource_group_name = azurerm_resource_group.flask-project.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nginx-nic1" {
  name                = "nginx-nic1"
  location            = azurerm_resource_group.flask-project.location
  resource_group_name = azurerm_resource_group.flask-project.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.flask-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.nginx-pub1.id
  }
}

resource "azurerm_virtual_machine" "flask-project" {
  name                  = "nginx1"
  location              = azurerm_resource_group.flask-project.location
  resource_group_name   = azurerm_resource_group.flask-project.name
  network_interface_ids = [azurerm_network_interface.nginx-nic1.id]
  vm_size               = "Standard_B2s"

  
  storage_os_disk {
    name              = "osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = "disk1"
    disk_size_gb      = 8
    caching           = "ReadWrite"
    create_option     = "Empty"
    managed_disk_type = "StandardSSD_LRS"
    lun               = 1
  }

    storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "nginx1"
    admin_username = "titi"
    admin_password = "Reborn1987"
  }

  os_profile_linux_config {
    disable_password_authentication = true
  }
 
}

resource "azurerm_public_ip" "nginx-pub2" {
  name                = "nginx-pub2"
  location            = azurerm_resource_group.flask-project.location
  resource_group_name = azurerm_resource_group.flask-project.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "nginx-nic2" {
  name                = "nginx-nic2"
  location            = azurerm_resource_group.flask-project.location
  resource_group_name = azurerm_resource_group.flask-project.name

  ip_configuration {
    name                          = "ipconfig2"
    subnet_id                     = azurerm_subnet.flask-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.nginx-pub2.id
  }
}

resource "azurerm_virtual_machine" "nginx2" {
  name                  = "nginx2"
  location              = azurerm_resource_group.flask-project.location
  resource_group_name   = azurerm_resource_group.flask-project.name
  network_interface_ids = [azurerm_network_interface.nginx-nic2.id]
  vm_size               = "Standard_B2s"

  
  storage_os_disk {
    name              = "osdisk2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_data_disk {
    name              = "disk2"
    disk_size_gb      = 8
    caching           = "ReadWrite"
    create_option     = "Empty"
    managed_disk_type = "StandardSSD_LRS"
    lun               = 1
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "nginx2"
    admin_username = "titi"
    admin_password = "Reborn1987"
  }

  os_profile_linux_config {
    disable_password_authentication = true
           
  }
}


