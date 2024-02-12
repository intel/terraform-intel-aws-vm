<p align="center">
  <img src="https://github.com/intel/terraform-intel-aws-vm/blob/main/images/logo-classicblue-800px.png?raw=true" alt="Intel Logo" width="250"/>
</p>

# Intel® Optimized Cloud Modules for Terraform

© Copyright 2024, Intel Corporation

## AWS M7i EC2 Instance with 4th Generation Intel® Xeon® Scalable Processor (Sapphire Rapids) & Intel® Cloud Optimized Recipe for Stable Diffusion

This demo will showcase Intel® OpenVino Optimized Stable Diffusion CPU inference using 4th Gen Xeon Scalable Processors with Intel® AMS on AWS.

## Architecture Diagram

<p align="center">
  <img src="https://github.com/intel/terraform-intel-aws-vm/blob/main/images/gen-ai-stable-diffusion.png?raw=true" alt="stable-diffusion" width="750"/>
</p>

## IMPORTANT:Modify variables.tf and add your public to cidr_blocks = "0.0.0.0/0". 

Use https://www.ipchicken.com/ to find your Public IP address


## Usage - Modify variables.tf and main.tf as needed

**variables.tf**

If needed, modify the region to target a specific AWS Region

```hcl
...

  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "192.0.0.0/8" 
      
    },

variable "region" {
  description = "Target AWS region to deploy EC2 in."
  type        = string
  default     = "us-east-1"
}

...
```

**main.tf**

If needed, modify main.tf

```hcl
...

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
    Name     = "stable-diffusion-test-vm-${random_id.rid.dec}"
    Owner    = "OwnerName-${random_id.rid.dec}",
    Duration = "2"
  }
}

...
```

## Running the Demo using AWS CloudShell

1. Open your AWS account and click the Cloudshell prompt (terminal button on top right of page)

2. Install Terraform

```bash
git clone https://github.com/tfutils/tfenv.git ~/.tfenv
mkdir ~/bin
ln -s ~/.tfenv/bin/* ~/bin/
tfenv install 1.6.0
tfenv use 1.6.0
```

3. Clone, if needed modify files, and run Terraform 

```bash
git clone https://github.com/intel/terraform-intel-aws-vm.git
cd terraform-intel-aws-vm/examples/gen-ai-stable-diffusion
# Make any necessary modifications to variables.tf and main.tf before running the Terraform commands below
terraform init 
terraform apply
```


```bash
WAIT ~3 MINUTES
```

4. After the Terraform module successfully creates the EC2 instance, **wait ~3 minutes** for the recipe to download/install pre-requisites and Stable Diffusion before continuing.

5. Navigate to the folder from where you ran **'terraform apply'**. Terraform created a **tfkey.private** key. 

2. Change the tfkey.private permissions 

    ```bash
    chmod 400 tfkey.private
    ```

3. SSH into your new Virtual Machine

    ```bash
    ssh ubuntu@<Public_IP_Address_EC2_Instance> -i tfkey.private
    ```

3. Once you are logged into the EC2 instance, run the command

    ```bash
    source /usr/local/bin/run_demo.sh
    ```

4. The application will download the Stable Diffusion Model and optimized it using Intel® OpenVino

5. When the application is ready, on your computer open a browser and **Browse to http://<VM_PLUBLIC_IP>:5000**

6. OPTIONAL - You can also start the default not-optimized demo by running.   **Browse to port 5001 instead http://<VM_PLUBLIC_IP>:5001**

    ```bash
    source /usr/local/bin/not_optimized_run_demo.sh
    ```

7. You can now generate images by entering prompts

8. To delete the demo, exit the VM instance by pressing Ctrl-C to break out of Stable Diffusion

```bash
terraform destroy  
```

## If not using the AWS Cloud Shell


1. Install AWS CLI and run ``` aws configure``` to configure your AWS credentials

2. Follow the same steps to run terraform, provision, ssh, and start the demo from your local workstation/laptop

## Considerations

- The AWS region where this example is run should have a default VPC
