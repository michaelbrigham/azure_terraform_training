provider "azurerm" {
  features {}
}

# Create a Resource Group
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

# Create a Virtual Network
resource "azurerm_virtual_network" "example" {
  name                = var.vnet_name
  address_space       = [var.address_space]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Create a Subnet
resource "azurerm_subnet" "example" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = [var.subnet_prefix]
}

# Create Network Interface for Web Server
resource "azurerm_network_interface" "web_nic" {
  name                = "web-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create Network Interface for Database Server
resource "azurerm_network_interface" "db_nic" {
  name                = "db-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Provision Ubuntu Web Server VM with Nginx
resource "azurerm_linux_virtual_machine" "web_server" {
  name                = var.web_vm_name
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = var.vm_size

  admin_username = var.admin_username
  admin_password = var.admin_password

  network_interface_ids = [azurerm_network_interface.web_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  # Provisioning script to install Nginx
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = var.admin_username
      private_key = file("~/.ssh/id_rsa")
      host        = azurerm_network_interface.web_nic.private_ip_address
    }

    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install nginx -y",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
  }
}

# Create Database Server VM (e.g., SQL Server on Linux)
resource "azurerm_linux_virtual_machine" "db_server" {
  name                = var.db_vm_name
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = var.vm_size

  admin_username = var.admin_username
  admin_password = var.admin_password

  network_interface_ids = [azurerm_network_interface.db_nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftSQLServer"
    offer     = "SQL2019-Linux"
    sku       = "Web"
    version   = "latest"
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("~/.ssh/id_rsa.pub")
  }
}