<p align="center">
  <img src="https://github.com/intel/terraform-intel-aws-vm/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Terraform Intel AWS VM - Windows VM in Default VPC

This example creates an AWS EC2 Instance on Intel Icelake CPU on Windows 2019 Server OS in default VPC. It is configured to create the EC2 instance in US-East-1 region. The region is provided in variables.tf in this example folder.

This example also creates an EC2 key pair. It associates the public key with the EC2 instance. The private key is created in the local system where terraform apply is done. It also creates a new scurity group to open up the RDP port 3389 to a specific IP CIDR block. Use the private key to generate the Windows login password (via RDP) following AWS prescribed documentation.

In this example, the tags Name, Owner and Duration are added to the EC2 instance when it is created.

## Usage

**See examples folder ./examples/amazon-windows-server-ec2-default-vpc**

variables.tf

```hcl
"region" {
  description = "Target AWS region to deploy EC2 in."
  type        = string
  default     = "us-east-1"
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
  ingress {
    from_port = 3389
    to_port   = 3389
    protocol  = "tcp"

    ## CHANGE THE IP CIDR BLOCK BELOW TO YOUR SPECIFIC REQUIREMENTS##
    #cidr_blocks = ["a.b.c.d/x"]
    cidr_blocks = ["123.456.789.012/32"] # Sample IP CIDR, Change to your own requirement here
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.ssh_security_group.id
  network_interface_id = module.ec2-vm.primary_network_interface_id
}

module "ec2-vm" {
  source   = "intel/aws-vm/intel"
  ami      = "ami-06371c9f2ad704460"
  key_name = "TF_key"
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
terraform apply 
```
## Considerations
- The AWS region where this example is run should have a default VPC