# Provision EC2 Spot Instance request on Icelake on Amazon Linux OS in default vpc. It is configured to create the EC2 in
# US-East-1 region. The region is provided in variables.tf in this example folder.

# To apply the changes, run command terraform apply. Once the spot request is created, check the status
# of the spot request in AWS Console or using CLI commands

# This example also creates an EC2 key pair. Associate the public key with the EC2 instance. Create the private key
# in the local system where terraform apply is done.

######### PLEASE NOTE TO CHANGE THE IP CIDR BLOCK TO ALLOW SSH FROM YOUR OWN ALLOWED IP ADDRESS FOR SSH #########

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

    ## CHANGE THE IP CIDR BLOCK BELOW TO ALL YOUR OWN SSH PORT ##
    #cidr_blocks = ["a.b.c.d/x"]
    cidr_blocks = ["136.52.34.139/32"]
  }
}

module "ec2-vm" {
  source   = "../../"
  create_spot_instance = true
  spot_wait_for_fulfillment = true
  key_name = aws_key_pair.TF_key.key_name
  vpc_security_group_ids = [aws_security_group.ssh_security_group.id]
}