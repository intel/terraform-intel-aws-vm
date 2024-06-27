# Provision EC2 Instance on Icelake on Amazon Linux OS in default vpc. It is configured to create the EC2 in
# US-East-1 region. The region is provided in variables.tf in this example folder.

# This example also create an EC2 key pair. Associate the public key with the EC2 instance. Create the private key
# in the local system where terraform apply is done. Create a new scurity group to open up the SSH port 
# 22 to a specific IP CIDR block

######### PLEASE NOTE TO CHANGE THE IP CIDR BLOCK TO ALLOW SSH FROM YOUR OWN ALLOWED IP ADDRESS FOR SSH #########

data "cloudinit_config" "ansible" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "cloud_init"
    content_type = "text/cloud-config"
    content = templatefile(
      "cloud_init.yml", 
      {
        HUGGINGFACEHUB_API_TOKEN=var.huggingface_token
      }
    )
  }
}

data "aws_ami" "ubuntu-linux-2204" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
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
  name_prefix = "ssh_security_group"
}

# Modify the `ingress_rules` variable in the variables.tf file to allow the required ports for your CIDR ranges
resource "aws_security_group_rule" "ingress_rules" {
  count             = length(var.ingress_rules)
  type              = "ingress"
  security_group_id = aws_security_group.ssh_security_group.id
  from_port         = var.ingress_rules[count.index].from_port
  to_port           = var.ingress_rules[count.index].to_port
  protocol          = var.ingress_rules[count.index].protocol
  cidr_blocks       = [var.ingress_rules[count.index].cidr_blocks]
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  count = length(module.ec2-vm)
  security_group_id    = aws_security_group.ssh_security_group.id
  network_interface_id = module.ec2-vm[count.index].primary_network_interface_id
}

# Modify the `vm_count` variable in the variables.tf file to create the required number of EC2 instances
module "ec2-vm" {
  count = var.vm_count
  source            = "intel/aws-vm/intel"
  key_name          = aws_key_pair.TF_key.key_name
  instance_type     = "m7i.16xlarge"
  availability_zone = "us-east-1d"
  ami               = data.aws_ami.ubuntu-linux-2204.id
  user_data         = data.cloudinit_config.ansible.rendered
 
  root_block_device = [{
    volume_size = "1000"
  }]

  tags = {
    Name     = "my-test-vm-${count.index}-${random_id.rid.dec}"
    Owner    = "owner-${random_id.rid.dec}",
    Duration = "2"
  }
}