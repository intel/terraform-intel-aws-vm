variable "region" {
  description = "Target AWS region to deploy EC2 in."
  type        = string
  default     = "us-east-1"
}

#Name of the system.
variable "name" {
  # default = "my-app-ec2-instance"
  # default = "test-web-instance"
  default = "mobile-app-user2"
}

# Defaults this is used for fallback if the system name isn't found in the densify_recommendations. 
# This shouldn't be used in most cases likely use would be if you were to create a new system that hasn't been analyzed by Densify yet.
variable "densify_fallback" {
  type = map(string)
  default = {
    recommendedType          = "m6i.large"
    currentType              = "m5.2xlarge"
    approvalType             = "all"
    savingsEstimate          = "0"
    predictedUptime          = "0"
    reservedInstanceCoverage = "no"
  }
}

variable "densify_recommendations" {
  type = map(map(string))
}