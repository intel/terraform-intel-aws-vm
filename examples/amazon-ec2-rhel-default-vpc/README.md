<p align="center">
  <img src="https://github.com/intel/terraform-intel-aws-vm/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Terraform Intel AWS VM - Red Hat RHEL VM in Default VPC

This example creates an AWS Red Hat Enterprise Linux (RHEL) EC2 instance on a 4th Generation Intel® Xeon® Scalable Processor (Sapphire Rapids) in the default VPC. It is configured to create the EC2 instance in US-East-1 region. The region is provided in variables.tf in this example folder.

This example also creates an EC2 key pair. It associates the public key with the EC2 instance. The private key is created in the local system where terraform apply is done. It also creates a new scurity group to open up the SSH port 22 to a specific IP CIDR block. This example requires RHEL SSM Parameter name for the ami_ssm_parameter in the variables file. More information can be found on [Red Hat Enterprise Linux Images Available on Amazon Web Services Documentation](<https://access.redhat.com/solutions/15356>)

In this example, the tags Name, Owner and Duration are added to the EC2 instance when it is created.

## Architecture Diagram
<p align="center">
  <img src="https://github.com/intel/terraform-intel-aws-vm/blob/main/images/amazon-ec2-rhel-default-vpc.png?raw=true" alt="amazon-ec2-rhel-default-vpc" width="750"/>
</p>

## Usage

variables.tf

```hcl
variable "region" {
  description = "Target AWS region to deploy EC2 in."
  type        = string
  default     = "us-east-1"
}

variable "ami_ssm_parameter" {
  description = "SSM parameter name for the AMI ID. For Red Hat Enterprise Image Documentation see [reference] (https://access.redhat.com/solutions/15356)."
  type        = string
  default     = "/aws/service/RHEL-9.0 0_HVM-20220513-x86_64-0-Hourly2-GP2"
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
  ami      = "ami-0c41531b8d18cc72b"
  tags = {
    Name     = "my-test-vm-${random_id.rid.dec}"
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
- It is important to change the ami_ssm_parameter variable in the variables.tf file to the correct name for the module to sucessfully run. Make sure to view the Red Hat documentation to make sure the name matches the correct AMI and region. More details can be found here: https://access.redhat.com/solutions/15356