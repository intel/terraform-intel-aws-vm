<p align="center">
  <img src="https://github.com/intel/terraform-intel-aws-vm/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Terraform Intel AWS VM - Spot Linux VM in Default VPC

This example creates EC2 Spot Instance request on Intel Icelake CPU on Amazon Linux OS in default vpc. It is configured to create the EC2 instance in US-East-1 region. The region is provided in variables.tf in this example folder.

To apply the changes, run command terraform apply. Once the spot request is created, check the status of the spot request in AWS Console or using CLI commands

This example also creates an EC2 key pair. It associates the public key with the EC2 instance. The private key is created in the local system where terraform apply is done. It also creates a new scurity group to open up the SSH port 22 to a specific IP CIDR block.

In this example, no tags are added to the EC2 instance when it is created from the fulfillment of the spot instance request.

## Usage

**See examples folder ./examples/amazon-linux-ec2-spot-default-vpc**

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
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    ## CHANGE THE IP CIDR BLOCK BELOW TO YOUR SPECIFIC REQUIREMENTS##
    #cidr_blocks = ["a.b.c.d/x"]
    cidr_blocks = ["123.456.789.012/32"] # Sample IP CIDR, Change to your own requirement here
  }
}

module "ec2-vm" {
  source   = "intel/aws-vm/intel"
  create_spot_instance = true
  spot_wait_for_fulfillment = true
  key_name = aws_key_pair.TF_key.key_name
  vpc_security_group_ids = [aws_security_group.ssh_security_group.id]
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
- This example creates a spot request. The creation of the Spot instance from the Spot request is based on availability of spot spare capacity in AWS