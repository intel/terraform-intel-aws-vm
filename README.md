

<p align="center">
  <img src="./images/logo-classicblue-800px.png" alt="Intel Logo" width="250"/>
</p>

# Intel® Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Module name

AWS Instance Types

## Usage

See examples folder for code ./examples/module-example-1/main.tf

Example of main.tf

```hcl
# Example of how to pass variable for database password:
# terraform apply -var="db_password=..."
# Environment variables can also be used https://www.terraform.io/language/values/variables#environment-variables

# Provision Intel Cloud Optimization Module
module "module-example" {
  source = "github.com/intel/module-name"
}

```

Run Terraform

```hcl
terraform init  
terraform plan
terraform apply

```

Note that this example may create resources. Run `terraform destroy` when you don't need these resources anymore.

## Considerations  