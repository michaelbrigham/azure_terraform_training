Create an Azure App Service and a container instance using Terraform. We'll use an Azure App Service Plan to host the app service, and we'll deploy a Docker container to the app service.

### **Terraform Configuration Example: Azure App Service with a Container Instance**

### **How the Configuration Works:**

1. **Provider and Resource Group:**
   - We're using the `azurerm` provider to interact with Azure and creating a resource group in a specified location.

2. **App Service Plan:**
   - The `azurerm_app_service_plan` block creates a basic-tier App Service Plan (`B1`), which is suitable for small workloads and testing.

3. **App Service with Docker Container:**
   - The `azurerm_app_service` block creates an Azure App Service and deploys a Docker container (in this case, `nginx:latest`) to it.
   - The container can be pulled from a public Docker registry, such as Docker Hub, or a private registry by setting the appropriate credentials using the `app_settings`.

4. **App Settings for Docker:**
   - The App Service is configured with Docker settings, including disabling App Service storage and configuring the Docker registry URL, username, and password for pulling images.

5. **Output:**
   - The output retrieves the default hostname for the app service, allowing you to access the deployed container instance.

### **Running the Configuration:**

1. **Initialize Terraform:**
   Run `terraform init` to initialize the working directory.

2. **Plan the Deployment:**
   Run `terraform plan -out=tfplan` to review and save the execution plan.

3. **Apply the Configuration:**
   Run `terraform apply tfplan` to deploy the app service and container instance.

4. **Access the App:**
   After deployment, use the `app_service_default_hostname` output to access the app. For example, it could be something like `example-app-service.azurewebsites.net`, which will serve the Nginx container.

### **Next Steps:**

- **Custom Container Images:** You can replace `nginx:latest` with a custom container image that you host on a private Docker registry.
- **Environment Variables:** You can add additional `app_settings` to pass environment variables to your container instance.
- **Scaling:** Upgrade the App Service Plan to a higher tier if you need more resources or autoscaling capabilities.
