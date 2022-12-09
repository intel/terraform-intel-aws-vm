# Provision EC2 Instance on Icelake on Aamzon Linux OS in default vpc
module "ec2-vm" {
  source         = "../../"
  tags = {
    Name = "my-test-vm"
    Owner = "Rajiv M",
    Duration = "2"
  }
}