### **main.tf** with Provisioning and Variables**

The `main.tf` file will be used to provision a web server and install and configure Nginx.

### **variables.tf**

The `variables.tf` file defines the customizable parts of the configuration to use variables for more flexibility, such as for the VM size, region and admin credentials.

### **How It Works:**

1. **Variables:**
   - This makes the configuration more reusable. For example, you can change the `vm_size`, `location`, `admin_username`, or even the VM names by passing different values for the variables. These values can be changed in the `terraform.tfvars` file or when running the commands.

2. **Provisioning the Web Server:**
   - Using the `remote-exec` provisioner, Terraform will SSH into the web server after it’s created and run a series of commands to install and start Nginx. This effectively turns your Ubuntu VM into a web server.

3. **Customization:** 
   - By using variables, the configuration becomes highly customizable. For instance, if you wanted to deploy in a different region or change the VM size, you only need to adjust the variable values.

### **Running the Configuration:**

1. **Initialize Terraform:**
   - Run `terraform init`.

2. **Plan the Deployment:**
   - Use `terraform plan -out=tfplan` to preview and save the changes.
   - Use `terraform plan -var="variable_name=value"` to update individual variables dynamically
   - Use `terraform plan -var-file="terraform.tfvars"` to load additional variables from a tfvars file

3. **Apply the Configuration:**
   - Run `terraform apply tfplan` to deploy both the web server and database server, along with the necessary networking infrastructure.

4. **Accessing the Web Server:**
   - Once deployed, the web server will be running Nginx, and you can access it via its private or public IP, depending on your setup.
