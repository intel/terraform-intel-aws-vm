variable "region" {
  description = "Target AWS region to deploy EC2 in."
  type        = string
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "Non-default VPC_ID to deploy EC2 in."
  type        = string
}