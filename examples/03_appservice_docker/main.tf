provider "azurerm" {
  features {}
}

# Create a Resource Group
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

# Create an App Service Plan
resource "azurerm_app_service_plan" "example" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku {
    tier = "Basic"
    size = "B1"
  }
}

# Create an App Service with a Docker Container
resource "azurerm_app_service" "example" {
  name                = var.app_service_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  site_config {
    linux_fx_version = "DOCKER|nginx:latest"
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_REGISTRY_SERVER_URL"          = var.docker_registry_url
    "DOCKER_REGISTRY_SERVER_USERNAME"     = var.docker_registry_username
    "DOCKER_REGISTRY_SERVER_PASSWORD"     = var.docker_registry_password
  }
}

# Outputs to retrieve the App Service URL
output "app_service_default_hostname" {
  value = azurerm_app_service.example.default_site_hostname
}
