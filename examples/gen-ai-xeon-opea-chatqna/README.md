<p align="center">
  <img src="https://github.com/intel/terraform-intel-aws-vm/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel® Optimized Cloud Modules for Terraform

© Copyright 2025, Intel Corporation

## AWS M7i EC2 Instance with 4th Generation Intel® Xeon® Scalable Processor (Sapphire Rapids) & Open Platform for Enterprise AI (OPEA) ChatQnA Example

This demo will showcase Retrieval Augmented Generation (RAG) CPU inference using 4th Gen Xeon Scalable Processors on AWS using the OPEA ChatQnA Example. For more information about OPEA, go [here](https://opea.dev/). For more information on this specific example, go [here](https://github.com/opea-project/GenAIExamples/tree/main/ChatQnA).

## Usage

### variables.tf

Modify the region to target a specific AWS Region

```hcl
variable "region" {
  description = "Target AWS region to deploy EC2 in."
  type        = string
  default     = "us-east-1"
}
```

Modify the Huggingface Token variable to your specific Huggingface Token, for information on creating a Huggingface token go [here](https://huggingface.co/docs/hub/en/security-tokens)

```hcl
variable "huggingface_token" {
  description = "Huggingface Token"
  default     = " <YOUR HUGGINGFACE TOKEN> "
  type        = string
}
```

### main.tf

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
  instance_type     = "m7i.8xlarge"
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

Run the Terraform Commands below to deploy the demos.

```Shell
terraform init
terraform plan
terraform apply
```

## Running the Demo using AWS CloudShell

Open your AWS account and click the Cloudshell prompt
At the command prompt enter in in these command prompts to install Terraform into the AWS Cloudshell

```Shell
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
mkdir ~/bin
ln -s ~/.tfenv/bin/* ~/bin/
tfenv install 1.3.0
tfenv use 1.3.0
```

Download and run the [OPEA ChatQnA on Xeon](https://github.com/intel/terraform-intel-aws-vm/tree/main/examples/gen-ai-xeon-opea-chatqna) Terraform Module by typing this command

```Shell
git clone https://github.com/intel/terraform-intel-aws-vm.git
```

Change into the `examples/gen-ai-xeon-opea-chatqna` example folder

```Shell
cd terraform-intel-aws-vm/examples/gen-ai-xeon-opea-chatqna
```

Run the Terraform Commands below to deploy the demos.

```Shell
terraform init
terraform plan
terraform apply
```

After the Terraform module successfully creates the EC2 instance, **wait ~15 minutes** for the recipe to build and launch the containers before continuing.

## Accessing the Demo

You can access the demos using the following:

- OPEA ChatQnA: `http://yourpublicip:5174`

- Note: This module is created using the m7i.16xlarge instance size, you can change your instance type by modifying the **instance_type = "m7i.16xlarge"** in the main.tf under the **ec2-vm module** section of the code. If you just change to an 8xlarge and then run **terraform apply** the module will destroy the old instance and rebuild with a larger instance size.

## Deleting the Demo

To delete the demo, run `terraform destroy` to delete all resources created.

## Considerations

- The AWS region where this example is run should have a default VPC
