<p align="center">
  <img src="./images/logo-classicblue-800px.png" alt="Intel Logo" width="250"/>
</p>

# Intel® Cloud Optimization Modules for Terraform  

© Copyright 2022, Intel Corporation

## HashiCorp Sentinel Policies

This file documents the HashiCorp Sentinel policies that apply to this module

## Policy 1

Description: The configured "instance_type" should be an Intel Xeon 3rd Generation(code-named Ice Lake) Scalable processors

Resource type: aws_instance

Parameter: instance_type

Allowed Types

- **Compute Optimized:** c6i.12xlarge,c6i.16xlarge,c6i.24xlarge,c6i.32xlarge,c6i.2xlarge,c6i.8xlarge,c6i.xlarge,c6i.large,c6i.metal,c6i.4xlarge,c6id.12xlarge,c6id.16xlarge,c6id.24xlarge,c6id.32xlarge,c6id.2xlarge,c6id.8xlarge,c6id.xlarge,c6id.large,c6id.metal,c6id.4xlarge,c6in.12xlarge,c6in.16xlarge,c6in.24xlarge,c6in.32xlarge,c6in.2xlarge,c6in.8xlarge,c6in.xlarge,c6in.large,c6in.4xlarge
- **Storage Optimized:** i4i.16xlarge,i4i.32xlarge,i4i.2xlarge,i4i.8xlarge,i4i.xlarge,i4i.large,i4i.metal,i4i.4xlarge
- **General Purpose:**  m6i.12xlarge,m6i.16xlarge,m6i.24xlarge,m6i.32xlarge,m6i.2xlarge,m6i.8xlarge,m6i.xlarge,m6i.large,m6i.metal,m6i.4xlarge,m6id.12xlarge,m6id.16xlarge,m6id.24xlarge,m6id.32xlarge,m6id.2xlarge,m6id.8xlarge,m6id.xlarge,m6id.large,m6id.metal,m6id.4xlarge,m6idn.12xlarge,m6idn.16xlarge,m6idn.24xlarge,m6idn.32xlarge,m6idn.2xlarge,m6idn.8xlarge,m6idn.xlarge,m6idn.large,m6idn.4xlarge,m6in.12xlarge,m6in.16xlarge,m6in.24xlarge,m6in.32xlarge,m6in.2xlarge,m6in.8xlarge,m6in.xlarge,m6in.large,m6in.4xlarge
- **Memory Optimized:** r6i.12xlarge,r6i.16xlarge,r6i.24xlarge,r6i.32xlarge,r6i.2xlarge,r6i.8xlarge,r6i.xlarge,r6i.large,r6i.metal,r6i.4xlarge,r6id.12xlarge,r6id.16xlarge,r6id.24xlarge,r6id.32xlarge,r6id.2xlarge,r6id.8xlarge,r6id.xlarge,r6id.large,r6id.metal,r6id.4xlarge,r6idn.12xlarge,r6idn.16xlarge,r6idn.24xlarge,r6idn.32xlarge,r6idn.2xlarge,r6idn.8xlarge,r6idn.xlarge,r6idn.large,r6idn.4xlarge,r6in.12xlarge,r6in.16xlarge,r6in.24xlarge,r6in.32xlarge,r6in.2xlarge,r6in.8xlarge,r6in.xlarge,r6in.large,r6in.4xlarge,x2idn.16xlarge,x2idn.24xlarge,x2idn.32xlarge,x2idn.metal,x2iedn.16xlarge,x2iedn.24xlarge,x2iedn.32xlarge,x2iedn.2xlarge,x2iedn.8xlarge,x2iedn.xlarge,x2iedn.metal,x2iedn.4xlarge
- **Accelerated Computing:**  trn1.32xlarge,trn1.2xlarge

## Links
https://aws.amazon.com/ec2/instance-types/ 

