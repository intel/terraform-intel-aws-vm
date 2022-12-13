# Provision EC2 Instance on Icelake on Amazon Linux OS in non-default vpc. The non-default VPC id is needed to be
# passed in this module as a variable.

# To terraform apply the changes, run command terraform apply -var="vpc_id=<YOUR-VPC-ID-HERE>"
# Example: terraform apply -var="vpc_id=vpc-0a6734z932p20c2m4"

# It is configured to create the EC2 in US-East-1 region. The region is provided in variables.tf in this example folder.

# This example also create an EC2 key pair. Associate the public key with the EC2 instance. Create the private key
# in the local system where terraform apply is done. Create a new scurity group to open up the SSH port 
# 22 to a specific IP CIDR block

######### PLEASE NOTE TO CHANGE THE IP CIDR BLOCK TO ALLOW SSH FROM YOUR OWN ALLOWED IP ADDRESS FOR SSH #########

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

    ## CHANGE THE IP CIDR BLOCK BELOW TO ALL YOUR OWN SSH PORT ##
    #cidr_blocks = ["a.b.c.d/x"]
    cidr_blocks = ["136.52.34.139/32"]
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