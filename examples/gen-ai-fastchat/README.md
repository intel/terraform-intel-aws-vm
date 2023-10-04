<p align="center">
  <img src="https://github.com/intel/terraform-intel-aws-vm/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel® Optimized Cloud Modules for Terraform

© Copyright 2022, Intel Corporation

## AWS M7i EC2 Instance with 4th Generation Intel® Xeon® Scalable Processor (Sapphire Rapids) & Intel® Cloud Optimized Recipe for FastChat

This demo will showcase Large Language Model(LLM) CPU inference using 4th Gen Xeon Scalable Processors on AWS using FastChat.

## Architecture Diagram
<p align="center">
  <img src="https://github.com/intel/terraform-intel-aws-vm/blob/main/images/gen-ai-fastchat.png?raw=true" alt="amazon-ec2-rhel-default-vpc" width="750"/>
</p>

## Usage


<b>variables.tf</b>

Modify the region to target a specific AWS Region

```hcl
variable "region" {
  description = "Target AWS region to deploy EC2 in."
  type        = string
  default     = "us-east-1"
}
```
<b>main.tf</b>

Modify settings in this file to choose your AMI as well as instance size and other details around the instance that will be created

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

## Running the Demo using AWS CloudShell
Open your AWS account and click the Cloudshell prompt<br>
At the command prompt enter in in these command prompts to install Terraform into the AWS Cloudshell
```Shell
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
mkdir ~/bin
ln -s ~/.tfenv/bin/* ~/bin/
tfenv install 1.3.0
tfenv use 1.3.0
```
Download and run the [gen-ai-fastchat](https://github.com/intel/terraform-intel-aws-vm/tree/main/examples/gen-ai-fastchat) Terraform Module by typing this command
```Shell
git clone https://github.com/intel/terraform-intel-aws-vm.git
```
Change into the fastchat example folder
```Shell
cd terraform-intel-aws-vm/examples/gen-ai-fastchat
```

Run the Terraform Commands below
```Shell
terraform init
terraform plan
terraform apply
```
```Shell
WAIT 10 MINUTES
```

After the Terraform module successfully creates the EC2 instance, **wait ~10 minutes** for the recipe to download/install FastChat and the LLM model before continuing.

1. Connect to the newly created AWS EC2 instance using SSH<br>
  
      a. The terraform module creates a key pair and adds the public key to the EC2 instance. It keeps the private key in the same folder from where the **terraform apply** was run. File name = tfkey.private<br>
  
    b. At your Terraform prompt, nagivate to the folder from where you ran the **terraform apply** command and change the permissions of the file:
    ```hcl
    chmod 400 tfkey.private
    ```

    c. Run the ssh command as below:
    ```hcl
    ssh ubuntu@<Public_IP_Address_EC2_Instance> -i tfkey.private
    ```

3. Once you are logged into the EC2 instance, run the command
    ```hcl
    source /usr/local/bin/run_demo.sh
    ```

4. Now you can access the Fastchat by opening your browser and entering the following URL     
http://yourpublicip:7860

5. Now you can enter your message or question in the chat prompt to see the Fastchat in action?
    * Note: This module is created using the m7i.4xlarge instance size, you can change your instance type by modifying the <b>
instance_type = "m7i.4xlarge"</b> in the main.tf under the <b>ec2-vm module</b> section of the code.<br>
If you just change to an 8xlarge and then run <b>terraform apply</b> the module will destroy the old instance and rebuild with a larger instance size.

5. To delete the demo:<br>
  a. Exit the VM instance by pressing Ctrl-C to break out of fastchat<br>
  b. Then run Terraform destroy to delete all resources created<br>

## Considerations
- The AWS region where this example is run should have a default VPC