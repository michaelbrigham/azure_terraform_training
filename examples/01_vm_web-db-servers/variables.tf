variable "subscription_id" {
  description = "The Azure subscription ID"
}

variable "location" {
  description = "The Azure region where resources will be created"
  default     = "East US"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  default     = "example-resources"
}

variable "vnet_name" {
  description = "The name of the virtual network"
  default     = "example-network"
}

variable "address_space" {
  description = "The address space of the virtual network"
  default     = "10.0.0.0/16"
}

variable "subnet_name" {
  description = "The name of the subnet"
  default     = "example-subnet"
}

variable "subnet_prefix" {
  description = "The IP address prefix for the subnet"
  default     = "10.0.2.0/24"
}

variable "vm_size" {
  description = "The size of the VMs"
  default     = "Standard_B1ms"
}

variable "admin_username" {
  description = "The admin username for the VMs"
  default     = "adminuser"
}

variable "admin_password" {
  description = "The admin password for the VMs"
  default     = "P@ssw0rd123!"
}

variable "web_vm_name" {
  description = "The name of the web server VM"
  default     = "web-server"
}

variable "db_vm_name" {
  description = "The name of the database server VM"
  default     = "db-server"
}

variable "nsg_name" {
  description = "The name of the Network Security Group"
  default     = "web-server-nsg"
}