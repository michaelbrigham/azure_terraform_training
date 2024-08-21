### **main.tf Breakdown:**

1. **Provider Configuration:**
   ```hcl
   provider "azurerm" {
     features {}
   }
   ```
   - **What it does:** This section tells Terraform which cloud provider to use—in this case, Azure via the `azurerm` provider. The `features {}` block is necessary, even though it's empty, to configure the provider's internal settings.
   - **Why it's important:** This configuration establishes the connection between Terraform and Azure, allowing Terraform to manage Azure resources.

2. **Resource Group:**
   ```hcl
   resource "azurerm_resource_group" "example" {
     name     = "example-resources"
     location = "East US"
   }
   ```
   - **What it does:** This block creates an Azure Resource Group named `example-resources` in the `East US` region.
   - **Why it's important:** Resource Groups are containers that hold related resources for an Azure solution. They make it easier to manage and organize resources, apply policies, and control costs.

3. **Virtual Network:**
   ```hcl
   resource "azurerm_virtual_network" "example" {
     name                = "example-network"
     address_space       = ["10.0.0.0/16"]
     location            = azurerm_resource_group.example.location
     resource_group_name = azurerm_resource_group.example.name
   }
   ```
   - **What it does:** This block creates a Virtual Network (VNet) named `example-network` with an address space of `10.0.0.0/16`. It is placed in the same location and resource group as defined earlier.
   - **Why it's important:** VNets are fundamental to Azure networking, providing a space to organize and secure resources. They allow you to set up isolated or interconnected environments in Azure.

4. **Subnet:**
   ```hcl
   resource "azurerm_subnet" "example" {
     name                 = "example-subnet"
     resource_group_name  = azurerm_resource_group.example.name
     virtual_network_name = azurerm_virtual_network.example.name
     address_prefixes     = ["10.0.2.0/24"]
   }
   ```
   - **What it does:** This block defines a subnet named `example-subnet` within the virtual network. The subnet's IP address range is `10.0.2.0/24`.
   - **Why it's important:** Subnets segment the VNet's address space into smaller, more manageable networks. This is crucial for organizing resources, controlling traffic, and applying security policies within the VNet.

5. **Network Interface:**
   ```hcl
   resource "azurerm_network_interface" "example" {
     name                = "example-nic"
     location            = azurerm_resource_group.example.location
     resource_group_name = azurerm_resource_group.example.name

     ip_configuration {
       name                          = "internal"
       subnet_id                     = azurerm_subnet.example.id
       private_ip_address_allocation = "Dynamic"
     }
   }
   ```
   - **What it does:** This creates a Network Interface named `example-nic` that is connected to the previously created subnet. The IP address will be dynamically assigned from the subnet's address space.
   - **Why it's important:** Network Interfaces (NICs) enable Azure VMs to communicate with other resources, the internet, or on-premises networks. Each VM requires a NIC to connect to a VNet.

6. **Virtual Machine:**
   ```hcl
   resource "azurerm_linux_virtual_machine" "example" {
     name                = "examplevm"
     resource_group_name = azurerm_resource_group.example.name
     location            = azurerm_resource_group.example.location
     size                = "Standard_DS1_v2"

     admin_username = "adminuser"
     admin_password = "P@ssw0rd123!"

     network_interface_ids = [azurerm_network_interface.example.id]

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
   }
   ```
   - **What it does:** This block creates a Linux Virtual Machine (VM) named `examplevm`. The VM uses the Standard_DS1_v2 size (one vCPU, 3.5GB RAM) and the latest Ubuntu 18.04-LTS image. It is connected to the previously created Network Interface. The admin credentials are also defined here.
   - **Why it's important:** This is the core of the configuration. The VM is the compute resource that will run your workloads. Terraform allows you to automate the VM provisioning process, including choosing its size, image, and network settings.

   - **os_disk Block:** Specifies the OS disk settings for the VM, such as storage type (Standard_LRS for standard local redundant storage) and caching (ReadWrite mode for better performance).
   - **source_image_reference Block:** This defines the operating system to be installed on the VM. In this case, it's a Canonical Ubuntu Server image.

### **Key Points to Remember:**
- **Modularity:** Terraform encourages modular infrastructure management. Each resource block handles a specific part of the infrastructure, like networking or compute.
- **Resource Dependencies:** Terraform automatically figures out the order in which to create resources. For example, the VM depends on the network interface, which in turn depends on the subnet and VNet.
- **Dynamic Configuration:** You can use variables (from a `variables.tf` file) to make your code dynamic and reusable across different environments (e.g., production, staging, development).
