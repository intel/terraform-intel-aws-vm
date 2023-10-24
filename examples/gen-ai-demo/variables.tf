variable "region" {
  description = "Target AWS region to deploy EC2 in."
  type        = string
  default     = "us-east-1"
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
      cidr_blocks = "0.0.0.0/0"
      
    },
    {
      from_port   = 7860
      to_port     = 7860
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      
    },
    {
      from_port   = 5000
      to_port     = 5000
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

# Variable for how many VMs to build
variable "vm_count" {
  description = "Number of VMs to build."
  type        = number
  default     = 1
}
