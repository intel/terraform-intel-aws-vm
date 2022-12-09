# Provision EC2 Instance on Icelake on Aamzon Linux OS in default vpc

  resource "random_id" "rid" {
    byte_length = 5
  }

module "ec2-vm" {
  source = "../../"
  tags = {
    Name     = "my-test-vm-${random_id.rid.dec}"
    Owner    = "OwnerName-${random_id.rid.dec}",
    Duration = "2"
  }
}