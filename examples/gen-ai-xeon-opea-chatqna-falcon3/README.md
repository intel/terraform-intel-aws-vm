<p align="center">
  <img src="https://github.com/intel/terraform-intel-aws-vm/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel® Optimized Cloud Modules for Terraform

# TII Falcon3-7B using OPEA RAG ChatQnA on AWS c7i Intel® Xeon® instances

© Copyright 2024, Intel Corporation

## Overview

This Module deploys the TII Falcon3-7B model using the Open Platform for Enterprise AI (OPEA) RAG ChatQnA example on a Intel® Xeon® c7i AWS Instance.

The TII Falcon3-7B model is a large language model (LLM) that is optimized for Intel® Advanced Matrix Extensions (AMX) and is hosted on Hugging Face.

[TII Falcon 3 - Click here more information](https://www.tii.ae/news/falcon-3-uaes-technology-innovation-institute-launches-worlds-most-powerful-small-ai-models)

The OPEA RAG ChatQnA example is a question and answer (QnA) chatbot that uses the TII Falcon3-7B model to answer questions from private documents using RAG. This example is optimized for Intel® Xeon® processors and can be run on any cloud provider or on-premises.

[Open Platform for Enterprise AI (OPEA) Project](https://opea.dev/)

[OPEA ChatQna Example link](https://github.com/opea-project/GenAIExamples/tree/main/ChatQnA).



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

## Usage from command line - Assumes you have Git, AWS CLI, and Terraform installed

```bash
# Clone the Repo
git clone https://github.com/intel/terraform-intel-aws-vm.git

# Change into the example folder
cd terraform-intel-aws-vm/examples/gen-ai-xeon-opea-chatqna-falcon3

# Run the Terraform Commands below to deploy the demo.
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

Provision the demo

```bash
# Clone the Repo
git clone https://github.com/intel/terraform-intel-aws-vm.git

# Change into the example folder
cd terraform-intel-aws-vm/examples/gen-ai-xeon-opea-chatqna-falcon3

# MODIFY VARIABLES.tf before continuining 

# Run the Terraform Commands below to deploy the demo.
terraform init
terraform plan
terraform apply
```

## Accessing the Demo

### Wait ~15 minutes for the components to be downloaded and installed before continuing

You can access the demos using the following:

- OPEA ChatQnA: `http://yourpublicip:5173`

- Note: This module is created using the c7i.24xlarge instance size, you can change your instance type by modifying the **instance_type = "c7i.24xlarge"** in the main.tf under the **ec2-vm module** section of the code. If you just change to an 16xlarge and then run **terraform apply** the module will destroy the old instance and rebuild with a larger instance size.

## Tips

1. To SSH into the instance, you can use the following command:

```bash
chmod 600 tfkey.private
ssh ubuntu@THE_PUBLIC_IP -i tfkey.private
```

2. To restart the software stack or to troubleshoot:

```bash

# Get root access
sudo bash

# Source variables
. /etc/profile.d/opea.sh

# Set OPEA docker image tag value
export TAG="1.0"

# Navigate to folder
cd /opt/GenAIExamples/ChatQnA/docker_compose/intel/cpu/xeon

# Stop 
docker compose -f compose2.yaml down

# Start
docker compose -f compose2.yaml up  # or docker compose -f compose2.yaml up -d
```

## Deleting the Demo

To delete the demo, run `terraform destroy` to delete all resources created.

## Considerations

- The AWS region where this example is run should have a default VPC
