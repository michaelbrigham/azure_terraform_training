# Terraform Training: Azure Resource Deployment and Management

## Introduction to Terraform

Terraform allows you to define and provision infrastructure as code (IaC). Terraform uses a high-level configuration language, HCL (HashiCorp Configuration Language) to define the resources.
This ensures a more controlled and predictable deployment process, which is especially important in larger or more complex infrastructures.


### **How Terraform Works with Azure**

When working with Azure, Terraform interacts with the Azure Resource Manager (ARM) to deploy and manage Azure services.

### Benefits of using Terraform with Azure

- **Modularity:** Terraform encourages modular infrastructure management. Each resource block handles a specific part of the infrastructure, like networking or compute.
- **Resource Dependencies:** Terraform automatically figures out the order in which to create resources. For example, the VM depends on the network interface, which in turn depends on the subnet and VNet.
- **Dynamic Configuration:** You can use variables (from a `variables.tf` file) to make your code dynamic and reusable across different environments (e.g., production, staging, development).

### **Services Deployed with Terraform on Azure**

- **Compute:** Deploy Azure Virtual Machines, scale sets, and functions.
- **Networking:** Create virtual networks, subnets, network interfaces, and security groups.
- **Storage:** Provision Azure Blob storage, managed disks, and file shares.
- **Databases:** Deploy managed databases like Azure SQL, Cosmos DB, etc.
- **Identity:** Manage Azure Active Directory, Service Principals, and RBAC roles.

#### **Terraform Basic Worklow Overview**
1. **Write:** You define your infrastructure using Terraform configuration files, which describe the resources you want in your cloud environment (e.g., VMs, storage, networks).
2. **Plan:** Terraform creates an execution plan to show what actions it will take to deploy or modify the infrastructure based on the configuration files.
3. **Apply:** Terraform applies the changes, deploying the resources on Azure.
4. **Manage:** After deployment, Terraform can continue to manage and update the infrastructure with configuration changes.

### **Prerequisites and Setup for Azure**
  - Install Terraform.
    - https://developer.hashicorp.com/terraform/install?ajs_aid=029f5761-7856-4cd5-8b32-0d6c3d94b63a&product_intent=terraform
  - Install Azure CLI.
  - Set up an Azure account and subscription.
  - Authenticating Terraform to Azure.
    - Using Azure CLI or service principal for authentication.
  - Configuring the Azure Provider in Terraform.

### **Deploying an Azure VM Using Terraform**

#### Code Example:
Here’s an example to show how you can use Terraform to deploy a basic Azure Virtual Machine. 

#### **1. Main Configuration File (main.tf)**

```hcl
provider "azurerm" {
  features {}
}

# Create a Resource Group
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}

# Create a Virtual Network
resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Create a Subnet
resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Create a Network Interface
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

# Create a Virtual Machine
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

#### **2. Variables File (variables.tf)**
This file defines variables that can be used in the `main.tf` file for more dynamic configurations.

```hcl
variable "location" {
  description = "The Azure region to deploy the resources"
  default     = "East US"
}
```

#### **3. Output File (outputs.tf)**
This file allows you to print useful information after deployment, like the VM’s public IP or resource group.

```hcl
output "resource_group_name" {
  value = azurerm_resource_group.example.name
}

output "virtual_machine_name" {
  value = azurerm_linux_virtual_machine.example.name
}
```

### **How to Use This Configuration:**

1. **Initialize Terraform:**
   Run `terraform init` to initialize your working directory. This command downloads the necessary providers and modules (in this case, the Azure provider).

2. **Plan Your Deployment:**
   There are two ways to run `terraform plan`:
   - **Regular `terraform plan`:** This command shows you a preview of what changes will be made to your infrastructure. It's useful for verifying that the configuration is correct before applying it.
   - **Save the Plan `terraform plan -out=tfplan`:** This variation saves the execution plan to a file. By using this option, you can ensure that when you apply the plan, the execution will happen exactly as it was previewed, even if changes have occurred in the environment since the plan was created.

3. **Apply Your Configuration:**
   - If you didn't save the plan, simply run `terraform apply` to deploy the resources to Azure.
   - If you saved the plan using the `-out` flag, apply it with `terraform apply tfplan` to make sure the resources are created exactly as they were defined in the plan file.

4. **Clean Up Resources:**
   When you’re done, you can run `terraform destroy` to remove all the resources created by Terraform.

