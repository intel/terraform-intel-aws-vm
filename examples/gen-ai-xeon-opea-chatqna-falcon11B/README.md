<p align="center">
  <img src="https://github.com/intel/terraform-intel-aws-vm/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel® Optimized Cloud Modules for Terraform 

# TII Falcon2-11B OPEA RAG ChatQnA on AWS c7i Intel® Xeon® instances

© Copyright 2025, Intel Corporation


## Overview

This Module deploys the TII Falcon2-11B model using the Open Platform for Enterprise AI (OPEA) RAG ChatQnA example on a Intel® Xeon® c7i AWS Instance. 

The TII Falcon2-11B model is a large language model (LLM) that is optimized for Intel® Advanced Matrix Extensions (AMX) and is hosted on Hugging Face. 

The OPEA RAG ChatQnA example is a question and answer (QnA) chatbot that uses the TII Falcon2-11B model to answer questions from private documents using RAG. This example is optimized for Intel® Xeon® processors and can be run on any cloud provider or on-premises.

This demo will showcase Retrieval Augmented Generation (RAG) CPU inference using 4th Gen Xeon Scalable Processors on AWS using the OPEA ChatQnA Example. For more information about OPEA, go [here](https://opea.dev/). For more information on this specific example, go [here](https://github.com/opea-project/GenAIExamples/tree/main/ChatQnA).

## Pre-requisites

1. A Huggingface Token, see: <https://huggingface.co/docs/hub/en/security-tokens>.
2. A default VPC on the AWS region being used.
3. If not using the AWS CloudShell
   1. Git client see: https://git-scm.com/downloads
   2. Terraform see: https://developer.hashicorp.com/terraform/install
   3. AWS CLI see: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html. 
   4. Run `aws configure` to set up your AWS credentials.

### variables.tf

Modify variables.tf to add Hugging Face Token, your region, Public IP and any other changes needed.

Use https://whatismyipaddress.com/ to find your Public IP.

```hcl
# Variable for Huggingface Token
variable "huggingface_token" {
  description = "Huggingface Token"
  default     = "<YOUR HUGGINGFACE TOKEN>" #UPDATE
  type        = string
}

variable "region" {
  description = "Target AWS region to deploy EC2 in."
  type        = string
  default     = "us-east-1" #UPDATE if needed
}

# Variable to add ingress rules to the security group. Replace the default values with the required ports and CIDR ranges.
variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = string
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0" #UPDATE if needed, ex: 192.10.50.42/32

    }
```

### main.tf

If there is a need to to modify the EC2 Instance, modify main.tf:

`instance_type     = "c7i.24xlarge"`

```hcl
module "ec2-vm" {
  source            = "intel/aws-vm/intel"
  key_name          = aws_key_pair.TF_key.key_name
  instance_type     = "c7i.24xlarge"
  availability_zone = "us-east-1a"
  ami               = data.aws_ami.ubuntu-linux-2204.id
  user_data         = data.cloudinit_config.ansible.rendered

  root_block_device = [{
    volume_size = "500"
  }]

  tags = {
    Name     = "my-test-vm-${random_id.rid.dec}"
    Owner    = "OwnerName-${random_id.rid.dec}",
    Duration = "2"
  }
}
```

## Usage

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

Download and run the [OPEA ChatQnA on Xeon](https://github.com/intel/terraform-intel-aws-vm/tree/main/examples/gen-ai-xeon-opea-chatqna-falcon11B) Terraform Module by typing this command

```Shell
git clone https://github.com/intel/terraform-intel-aws-vm.git
```

Change into the `examples/gen-ai-xeon-opea-chatqna-falcon11B` example folder

```Shell
cd terraform-intel-aws-vm/examples/gen-ai-xeon-opea-chatqna-falcon11B
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

- Note: This module is created using the c7i.24xlarge instance size, you can change your instance type by modifying the **instance_type = "c7i.24xlarge"** in the main.tf under the **ec2-vm module** section of the code. If you just change to an 16xlarge and then run **terraform apply** the module will destroy the old instance and rebuild with a larger instance size.

## Deleting the Demo

To delete the demo, run `terraform destroy` to delete all resources created.

## Considerations

- The AWS region where this example is run should have a default VPC
