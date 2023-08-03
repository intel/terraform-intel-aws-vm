# Provision a capacity reservation in AWS availability zone us-east-1d. This capacity reservation will be for
# instance type m7i.large for Linux/UNIX in this availability zone. Instance eligibility for this capacity
# reservation will be targetted.

# Provision EC2 Instance on Sapphire Rapids on Amazon Linux OS in default vpc using the targetted capacity reservation 
# created in the above step. The EC2 is configured to create the EC2 in US-East-1 region. The region is provided
# in variables.tf in this example folder.

# This example also create an EC2 key pair. Associate the public key with the EC2 instance. Create the private key
# in the local system where terraform apply is done. Create a new scurity group to open up the SSH port 
# 22 to a specific IP CIDR block

######### PLEASE NOTE TO CHANGE THE IP CIDR BLOCK TO ALLOW SSH FROM YOUR OWN ALLOWED IP ADDRESS FOR SSH #########

# Create capacity reservation for EC2
resource "aws_ec2_capacity_reservation" "thiscapacity" {
  instance_type           = "m7i.large"
  instance_platform       = "Linux/UNIX"
  availability_zone       = "us-east-1d"
  instance_match_criteria = "targeted"
  instance_count          = 1
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