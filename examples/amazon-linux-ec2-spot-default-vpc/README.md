<p align="center">
  <img src="https://github.com/intel/terraform-intel-aws-vm/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel® Optimized Cloud Modules for Terraform

© Copyright 2022, Intel Corporation

## Terraform Intel AWS VM - Spot Linux VM in Default VPC

This example creates EC2 Spot Instance request on 4th Generation Intel® Xeon® Scalable Processor (Sapphire Rapids) on Amazon Linux OS in default vpc. It is configured to create the EC2 instance in US-East-1 region. The region is provided in variables.tf in this example folder.

To apply the changes, run command terraform apply. Once the spot request is created, check the status of the spot request in AWS Console or using CLI commands

This example also creates an EC2 key pair. It associates the public key with the EC2 instance. The private key is created in the local system where terraform apply is done. It also creates a new scurity group to open up the SSH port 22 to a specific IP CIDR block.

In this example, no tags are added to the EC2 instance when it is created from the fulfillment of the spot instance request.

**As of 04-Aug-2023, AWS support confirmed that M7i/M7i-flex instances are not available in all availability zones of AWS US-East-1 region. Hence added the availability zone in this example where these instance types are available.**

## Architecture Diagram
<p align="center">
  <img src="https://github.com/intel/terraform-intel-aws-vm/blob/main/images/amazon-ec2-spot-default-vpc.png?raw=true" alt="amazon-ec2-rhel-default-vpc" width="750"/>
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
resource "random_id" "rid" {
  byte_length = 5
}

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

module "ec2-vm" {
  source                    = "intel/aws-vm/intel"
  create_spot_instance      = true
  spot_wait_for_fulfillment = true
  key_name                  = aws_key_pair.TF_key.key_name
  vpc_security_group_ids    = [aws_security_group.ssh_security_group.id]
  availability_zone         = "us-east-1d"
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
- This example creates a spot request. The creation of the Spot instance from the Spot request is based on availability of spot spare capacity in AWS