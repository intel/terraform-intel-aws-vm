<p align="center">
  <img src="https://github.com/intel/terraform-intel-aws-vm/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel® Optimized Cloud Modules for Terraform

© Copyright 2025, Intel Corporation

## Terraform Intel AWS VM - Linux VM in Default VPC using Intel Cloud Optimzier by Densify recommendations
<p align="center">
  <img src="https://github.com/intel/terraform-intel-aws-vm/blob/main/images/aws-ec2-ico.png?raw=true" alt="Intel + Densify Logo" width="250"/>
</p>

This example creates creates AWS EC2 instance on Linux Operating System in the default VPC using recommended instance from Intel Cloud Optimizer by Densify. 

Intel® Cloud Optimizer is a collaboration between Densify and Intel targeted at getting you the most from your cloud investment. 

Intel Cloud Optimizer by Densify helps customers optimize their cloud investments and ensure optimal performance for every workload.

Using this example requires a "densify_recommndations.auto.tfvars" file. You are expected to generate this file so this is a sample file only. 

In this sample file we will use example of recommended instance type of m6i.xlarge. 

Intel Cloud Optimizer by Densify is a commercial product. With Intel® Cloud Optimizer, Intel funds the use of Densify for qualifying enterprises for 12 months. For full details of the Intel Cloud Optimizer by Densify offer please see: [INTEL CLOUD OPTIMIZER by DENSIFY](https://www.densify.com/product/intel/)

This example is is configured to create the EC2 instance in US-East-1 region. The region is provided in variables.tf in this example folder.

This example also creates an EC2 key pair. It associates the public key with the EC2 instance. The private key is created in the local system where terraform apply is done. It also creates a new scurity group to open up the SSH port 22 to a specific IP CIDR block.

In this example, the tags Name, Owner and Duration are added to the EC2 instance when it is created and with optional tags for Intel Cloud Optimizer by Densify. Make sure you have the "densify_recommendation.auto.tfvars" file in this example folder.

## Architecture Diagram
<p align="center">
  <img src="https://github.com/intel/terraform-intel-aws-vm/blob/main/images/amazon-ec2-default-vpc.png?raw=true" alt="amazon-ec2-default-vpc" width="750"/>
</p>

## Usage

variables.tf

```hcl
variable "region" {
  description = "Target AWS region to deploy EC2 in."
  type        = string
  default     = "us-east-1"
}
```
main.tf
```hcl
module "densify" {
  source  = "densify-dev/optimization-as-code/null"
  densify_recommendations = var.densify_recommendations
  densify_fallback        = var.densify_fallback
  densify_unique_id       = var.name
}

resource "random_id" "rid" {
  byte_length = 5
}

# RSA key of size 4096 bits
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key-${random_id.rid.dec}"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "TF_private_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tfkey.private"
}

resource "aws_security_group" "ssh_security_group" {
  description = "security group to configure ports for ssh"
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    ## CHANGE THE IP CIDR BLOCK BELOW TO ALL YOUR OWN SSH PORT ##
    cidr_blocks = ["a.b.c.d/x"]
     
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.ssh_security_group.id
  network_interface_id = module.ec2-vm.primary_network_interface_id
}

module "ec2-vm" {
  source   = "intel/aws-vm/intel"
  key_name = aws_key_pair.TF_key.key_name
  instance_type = module.densify.recommended_type
  # tag instance to make it Self-Aware these tags are optional and can set as few or as many as you like.
  tags = {
    Name                              = var.name
    #Should match the densify_unique_id value as this is how Densify references the system as unique
    "Provisioning ID"                 = var.name
    "business-unit"                   = "Intel"
    "application"                     = "BDC_Slc"
    "environment"                     = "PRV-BDC_Slc"
    Densify-optimal-instance-type     = module.densify.recommended_type
    Owner    = "OwnerName-${random_id.rid.dec}",
    Duration = "2"
  }
}
```



Run Terraform
Replace the line below with you own IPV4 CIDR range before running the example.

```hcl
cidr_blocks = ["a.b.c.d/x"]
```

Run the following terraform commands
```hcl
terraform init  
terraform plan
terraform apply  
```
## Considerations
- The AWS region where this example is run should have a default VPC
