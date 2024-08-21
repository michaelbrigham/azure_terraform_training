variable "location" {
  description = "The Azure region where resources will be created"
  default     = "East US"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  default     = "example-resources"
}

variable "app_service_plan_name" {
  description = "The name of the app service plan"
  default     = "example-app-service-plan"
}

variable "app_service_name" {
  description = "The name of the app service"
  default     = "example-app-service"
}

variable "docker_registry_url" {
  description = "The URL of the Docker registry"
  default     = "https://index.docker.io"
}

variable "docker_registry_username" {
  description = "The username for the Docker registry"
}

variable "docker_registry_password" {
  description = "The password for the Docker registry"
}
