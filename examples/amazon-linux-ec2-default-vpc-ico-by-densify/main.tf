# Provision EC2 Instance on Icelake on Amazon Linux OS in default vpc. It is configured to create the EC2 in
# US-East-1 region. The region is provided in variables.tf in this example folder.

# This example also create an EC2 key pair. Associate the public key with the EC2 instance. Create the private key
# in the local system where terraform apply is done. Create a new scurity group to open up the SSH port 
# 22 to a specific IP CIDR block

######### PLEASE NOTE TO CHANGE THE IP CIDR BLOCK TO ALLOW SSH FROM YOUR OWN ALLOWED IP ADDRESS FOR SSH #########

# Initialize Densify Module that will parse the densify_recommendations.auto.tfvars recommendation file
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