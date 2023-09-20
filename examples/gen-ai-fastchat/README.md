<p align="center">
  <img src="https://github.com/intel/terraform-intel-aws-vm/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="750"/>
</p>

# Intel Cloud Optimization Modules for Terraform

© Copyright 2022, Intel Corporation

## AWS M7i EC2 Instance with 4th Generation Intel® Xeon® Scalable Processor (Sapphire Rapids) & Intel® Cloud Optimized Recipe for FastChat

This demo will showcase Large Language Model(LLM) CPU inference using 4th Gen Xeon Scalable Processors on AWS using FastChat.

## Architecture Diagram
<p align="center">
  <img src="https://github.com/intel/terraform-intel-aws-vm/blob/main/images/gen-ai-fastchat.png?raw=true" alt="amazon-ec2-rhel-default-vpc" width="250"/>
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
## Get latest Ubuntu 22.04 AMI in AWS for x86
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

module "ec2-vm" {
  source            = "intel/aws-vm/intel"
  key_name          = aws_key_pair.TF_key.key_name
  instance_type     = "m7i.4xlarge"
  availability_zone = "us-east-1a"
  ami               = data.aws_ami.ubuntu-linux-2204.id
  user_data         = data.cloudinit_config.ansible.rendered

  root_block_device = [{
    volume_size = "100"
  }]

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

After **terraform apply** completes, wait about 10 mins. During this time, the Ansible recipe will download/install FastChat and the LLM model


## Running the Demo
1. As mentioned above, **wait ~10 minutes** for the Recipe to download/install FastChat and the LLM model before continuing
2. SSH into newly created AWS EC2 instance. 
3. The terraform module creates a key pair and adds the public key to the EC2 instance. It keeps the private key in the same folder from where the **terraform apply** was run.
4. Open command prompt on your computer. Nagivate to the folder from where you ran the **terraform apply** command.
5. Run the ssh command as below:
```hcl
ssh ubuntu@<Public_IP_Address_EC2_Instance> -i tfkey.private
```
6. Once you are logged into the EC2 instance, **run `source /usr/local/bin/run_demo.sh`**
7. Your app will be proxied through gradio. See https://xxxxxxx.gradio.live URL that is generated during the run_demo.sh script execution.
8. Open a browser and put the gradio url referenced in the prior step

<p align="center">
  <img src="https://github.com/intel/terraform-intel-aws-vm/blob/main/images/gradio.png?raw=true" alt="Gradio_Output" width="750"/>
</p>

## Known Issues

The demo may initially fail. In this case, run

```hcl
pip install gradio==3.10
```
```hcl 
pip install gradio==3.35.2
```

Then, run below command on the terminal of the EC2 instance after you have SSH into the instance:
```hcl
source /usr/local/bin/run_demo.sh
``` 

And navigate again using your browser.

## Considerations
- The AWS region where this example is run should have a default VPC