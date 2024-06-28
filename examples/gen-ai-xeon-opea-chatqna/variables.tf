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
      from_port   = 6379
      to_port     = 6379
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      
    },
    {
      from_port   = 8001
      to_port     = 8001
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 6006
      to_port     = 6006
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 6007
      to_port     = 6007
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 6000
      to_port     = 6000
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 7000
      to_port     = 7000
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8808
      to_port     = 8808
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8000
      to_port     = 8000
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 9009
      to_port     = 9009
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 9000
      to_port     = 9000
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8888
      to_port     = 8888
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 5173
      to_port     = 5173
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 5174
      to_port     = 5174
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

# Variable for Huggingface Token
variable "huggingface_token" {
  description = "Huggingface Token"
  default     = " <YOUR HUGGINGFACE TOKEN> "
  type        = string
}