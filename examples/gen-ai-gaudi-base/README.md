<p align="center">
  <img src="https://github.com/intel/terraform-intel-aws-vm/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel® Optimized Cloud Modules for Terraform

© Copyright 2025, Intel Corporation

## AWS DL1 EC2 Instance with Intel Gaudi Accelerators

This demo will showcase Large Language Model(LLM) inference using Intel Gaudi AI Accelerators. This module will install the base software required to run other examples.

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

### main.tf

Modify settings in this file to choose your AMI as well as other details around the instance that will be created. This demo was tested on Ubuntu 22.04.

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
  instance_type     = "dl1.24xlarge"
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

Download and run the [Gen-AI-Gaudi-Demo](https://github.com/intel/terraform-intel-aws-vm/tree/main/examples/gen-ai-gaudi-base) Terraform Module by typing this command

```Shell
git clone https://github.com/intel/terraform-intel-aws-vm.git
```

Change into the `examples/gen-ai-gaudi-base` example folder

```Shell
cd terraform-intel-aws-vm/examples/gen-ai-gaudi-demo
```

Run the Terraform Commands below to deploy the demos.

```Shell
terraform init
terraform plan
terraform apply
```

After the Terraform module successfully creates the EC2 instance, **wait ~15 minutes** for the recipe to download/install the Intel Gaudi driver and software. After the deployment is done, you can launch the Habana Gaudi PyTorch container using the following:

```bash
sudo docker run -it --runtime=habana -e HABANA_VISIBLE_DEVICES=all -e OMPI_MCA_btl_vader_single_copy_mechanism=none --cap-add=sys_nice --net=host --ipc=host vault.habana.ai/gaudi-docker/1.15.1/ubuntu22.04/habanalabs/pytorch-installer-2.2.0:latest
```

## Deleting the Demo

To delete the demo, run `terraform destroy` to delete all resources created.

## Considerations

- The AWS region where this example is run should have a default VPC

## Links

[Intel® Gaudi® AI Accelerator](https://www.intel.com/content/www/us/en/products/details/processors/ai-accelerators/gaudi-overview.html)

[Intel® Gaudi® AI Accelerator - Developer Website](https://developer.habana.ai/)
