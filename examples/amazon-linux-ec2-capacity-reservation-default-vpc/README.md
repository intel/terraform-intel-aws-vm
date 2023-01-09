<p align="center">
  <img src="https://github.com/OTCShare2/terraform-intel-hashicorp/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## Terraform Intel AWS VM - Linux VM with Capacity Reservation in Default VPC

This example provisions a capacity reservation in AWS availability zone us-east-1d. This capacity reservation is used for instance type m6i.large for Linux/UNIX in this availability zone. Instance eligibility for this capacity reservation will be targetted.

Following the capacity reservation, it provisions an EC2 Instance on Icelake on Amazon Linux OS in default vpc using the targetted capacity reservation  created in the above step. It creates the EC2 instance in US-East-1 region. The region is provided in variables.tf in this example folder.

This example also creates an EC2 key pair. It associates the public key with the EC2 instance. The private key is created in the local system where terraform apply is done. It also creates a new scurity group to open up the SSH port 22 to a specific IP CIDR block.

In this example, the tags Name, Owner and Duration are added to the EC2 instance when it is created.

## Usage

**See examples folder ./examples/amazon-linux-ec2-capacity-reservation-default-vpc**

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
# Create capacity reservation for EC2
resource "aws_ec2_capacity_reservation" "thiscapacity" {
  instance_type     = "m6i.large"
  instance_platform = "Linux/UNIX"
  availability_zone = "us-east-1d"
  instance_match_criteria = "targeted"
  instance_count    = 1
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

    ## CHANGE THE IP CIDR BLOCK BELOW TO YOUR SPECIFIC REQUIREMENTS ##
    #cidr_blocks = ["a.b.c.d/x"]
    cidr_blocks = ["123.456.789.012/32"] # Sample IP CIDR, Change to your own requirement here
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.ssh_security_group.id
  network_interface_id = module.ec2-vm.primary_network_interface_id
}

module "ec2-vm" {
  source   = "../../"
  key_name = "TF_key"
  capacity_reservation_specification = {
    capacity_reservation_target = {
      capacity_reservation_id = aws_ec2_capacity_reservation.thiscapacity.id
    }
  }
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
- If capacity reservation cannot be created due to availability of resources in AWS, please work with your AWS Support Team to resolve the issue