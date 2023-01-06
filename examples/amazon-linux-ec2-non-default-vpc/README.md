<p align="center">
  <img src="https://github.com/OTCShare2/terraform-intel-hashicorp/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Terraform Intel AWS VM - Linux VM in Non Default VPC

This example creates an AWS EC2 instance on Intel Icelake CPU on Linux Operating System in a non-default VPC. The non-default VPC id is needed to be passed in this module as a variable. It is configured to create the EC2 instance in US-East-1 region. The region is provided in variables.tf in this example folder.

This example also creates an EC2 key pair. It associates the public key with the EC2 instance. The private key is created in the local system where terraform apply is done. It also creates a new scurity group to open up the SSH port 22 to a specific IP CIDR block.

In this example, the tags Name, Owner and Duration are added to the EC2 instance when it is created.

## Usage

**See examples folder ./examples/amazon-linux-ec2-non-default-vpc**

variables.tf

```hcl
variable "region" {
  description = "Target AWS region to deploy EC2 in."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "Non-default VPC_ID to deploy EC2 in."
  type        = string
}
```
main.tf
```hcl
resource "random_id" "rid" {
  byte_length = 5
}

# RSA key of size 4096 bits
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "TF_private_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tfkey.private"
}

resource "aws_security_group" "ssh_security_group" {
  description = "security group to configure ports for ssh"
  vpc_id      = var.vpc_id
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    ## CHANGE THE IP CIDR BLOCK BELOW TO YOUR SPECIFIC REQUIREMENTS##
    #cidr_blocks = ["a.b.c.d/x"]
    cidr_blocks = ["123.456.789.012/32"] # Sample IP CIDR, Change to your own requirement here
  }
}

# Identifying subnets from the vpc provided above. The subnet will be used to create the EC2 istance
data "aws_subnets" "vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.ssh_security_group.id
  network_interface_id = module.ec2-vm.primary_network_interface_id
}

module "ec2-vm" {
  source    = "../../"
  key_name  = "TF_key"
  subnet_id = data.aws_subnets.vpc_subnets.ids[0]
  tags = {
    Name     = "my-test-vm-${random_id.rid.dec}"
    Owner    = "OwnerName-${random_id.rid.dec}",
    Duration = "2"
  }
}
```



Run Terraform

```hcl
terraform init  
terraform plan
terraform apply -var="vpc_id=<Your non-default VPC ID>"
## Example: terraform apply -var="vpc_id=vpc-0a6734z932phj64ls" ##
```
## Considerations
- The VPC Id provided in the terraform apply should exist in the specific AWS region where this example is being applied