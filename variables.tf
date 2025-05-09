########################
####     Intel      ####
########################

# See policies.md, Intel recommends the 4th Generation Intel® Xeon® Platinum (Sapphire Rapids) based instances.
#Compute Optimized: c7i.large,c7i.xlarge,c7i.2xlarge,c7i.4xlarge,c7i.8xlarge,c7i.12xlarge,c7i.16xlarge,c7i.24xlarge,c7i.48xlarge,c7i.metal-24xl,c7i.metal-48xl,c6i.12xlarge,c6i.16xlarge,c6i.24xlarge,c6i.32xlarge,c6i.2xlarge,c6i.8xlarge,c6i.xlarge,c6i.large,c6i.metal,c6i.4xlarge,c6id.12xlarge,c6id.16xlarge,c6id.24xlarge,c6id.32xlarge,c6id.2xlarge,c6id.8xlarge,c6id.xlarge,c6id.large,c6id.metal,c6id.4xlarge,c6in.12xlarge,c6in.16xlarge,c6in.24xlarge,c6in.32xlarge,c6in.2xlarge,c6in.8xlarge,c6in.xlarge,c6in.large,c6in.4xlarge
#Storage Optimized: i7i.large, i7i.xlarge, i7i.2xlarge, i7i.4xlarge, i7i.8xlarge, i7i.12xlarge, i7i.16xlarge, i7i.24xlarge, i7i.48xlarge, i7i.metal-24xl, i7i.metal-48xl
#General Purpose:  m7i.large,m7i.xlarge,m7i.2xlarge,m7i.4xlarge,m7i.8xlarge,m7i.12xlarge,m7i.16xlarge,m7i.24xlarge,m7i.48xlarge,m7i.metal-24xl,m7i.metal-48xl,m7i-flex.large,m7i-flex.xlarge,m7i-flex.2xlarge,m7i-flex.4xlarge,m7i-flex.8xlarge,m6i.12xlarge,m6i.16xlarge,m6i.24xlarge,m6i.32xlarge,m6i.2xlarge,m6i.8xlarge,m6i.xlarge,m6i.large,m6i.metal,m6i.4xlarge,m6id.12xlarge,m6id.16xlarge,m6id.24xlarge,m6id.32xlarge,m6id.2xlarge,m6id.8xlarge,m6id.xlarge,m6id.large,m6id.metal,m6id.4xlarge,m6idn.12xlarge,m6idn.16xlarge,m6idn.24xlarge,m6idn.32xlarge,m6idn.2xlarge,m6idn.8xlarge,m6idn.xlarge,m6idn.large,m6idn.4xlarge,m6in.12xlarge,m6in.16xlarge,m6in.24xlarge,m6in.32xlarge,m6in.2xlarge,m6in.8xlarge,m6in.xlarge,m6in.large,m6in.4xlarge
#Memory Optimized: r7i.large,r7i.xlarge,r7i.2xlarge,r7i.4xlarge,r7i.8xlarge,r7i.12xlarge,r7i.16xlarge,r7i.24xlarge,r7i.48xlarge,r7i.metal-24xl,r7i.metal-48xl,r7iz.large,r7iz.xlarge,r7iz.2xlarge,r7iz.4xlarge,r7iz.8xlarge,r7iz.12xlarge,r7iz.16xlarge,r7iz.32xlarge,r7iz.metal-16xl,r7iz.metal-32xl,r6i.12xlarge,r6i.16xlarge,r6i.24xlarge,r6i.32xlarge,r6i.2xlarge,r6i.8xlarge,r6i.xlarge,r6i.large,r6i.metal,r6i.4xlarge,r6id.12xlarge,r6id.16xlarge,r6id.24xlarge,r6id.32xlarge,r6id.2xlarge,r6id.8xlarge,r6id.xlarge,r6id.large,r6id.metal,r6id.4xlarge,r6idn.12xlarge,r6idn.16xlarge,r6idn.24xlarge,r6idn.32xlarge,r6idn.2xlarge,r6idn.8xlarge,r6idn.xlarge,r6idn.large,r6idn.4xlarge,r6in.12xlarge,r6in.16xlarge,r6in.24xlarge,r6in.32xlarge,r6in.2xlarge,r6in.8xlarge,r6in.xlarge,r6in.large,r6in.4xlarge,x2idn.16xlarge,x2idn.24xlarge,x2idn.32xlarge,x2idn.metal,x2iedn.16xlarge,x2iedn.24xlarge,x2iedn.32xlarge,x2iedn.2xlarge,x2iedn.8xlarge,x2iedn.xlarge,x2iedn.metal,x2iedn.4xlarge
#Accelerated Computing:  trn2.48xlarge,trn2u.48xlarge
# See more:
# https://aws.amazon.com/ec2/instance-types/ 

variable "instance_type" {
  description = "Instance SKU, see comments above for guidance"
  type        = string
  default     = "m7i.large"
}

########################
####    Required    ####
########################
variable "create" {
  description = "Whether to create an instance"
  type        = bool
  default     = true
}

variable "name" {
  description = "Name to be used on EC2 instance created"
  type        = string
  default     = ""
}

variable "ami_ssm_parameter" {
  description = "SSM parameter name for the AMI ID. For Amazon Linux AMI SSM parameters see [reference](https://docs.aws.amazon.com/systems-manager/latest/userguide/parameter-store-public-parameters-ami.html). To find the latest Windows AMI using Systems Manager, use this [reference](https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/finding-an-ami.html#finding-an-ami-parameter-store)"
  type        = string
  default     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = null
}

variable "availability_zone" {
  description = "AZ to start the instance in"
  type        = string
  default     = null
}

variable "capacity_reservation_specification" {
  description = "Describes an instance's Capacity Reservation targeting option"
  type        = any
  default     = {}
}

variable "cpu_credits" {
  description = "The credit option for CPU usage (unlimited or standard)"
  type        = string
  default     = null
}

variable "disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection"
  type        = bool
  default     = null
}

variable "ebs_block_device" {
  description = "Additional EBS block devices to attach to the instance"
  type        = list(map(string))
  default     = []
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance will be EBS-optimized"
  type        = bool
  default     = null
}

variable "enclave_options_enabled" {
  description = "Whether Nitro Enclaves will be enabled on the instance. Defaults to `false`"
  type        = bool
  default     = null
}

variable "ephemeral_block_device" {
  description = "Customize Ephemeral (also known as Instance Store) volumes on the instance"
  type        = list(map(string))
  default     = []
}

variable "get_password_data" {
  description = "If true, wait for password data to become available and retrieve it."
  type        = bool
  default     = null
}

variable "hibernation" {
  description = "If true, the launched EC2 instance will support hibernation"
  type        = bool
  default     = null
}

variable "host_id" {
  description = "ID of a dedicated host that the instance will be assigned to. Use when an instance is to be launched on a specific dedicated host"
  type        = string
  default     = null
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile"
  type        = string
  default     = null
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior for the instance. Amazon defaults this to stop for EBS-backed instances and terminate for instance-store instances. Cannot be set on instance-store instance" # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/terminating-instances.html#Using_ChangingInstanceInitiatedShutdownBehavior
  type        = string
  default     = null
}

variable "ipv6_address_count" {
  description = "A number of IPv6 addresses to associate with the primary network interface. Amazon EC2 chooses the IPv6 addresses from the range of your subnet"
  type        = number
  default     = null
}

variable "ipv6_addresses" {
  description = "Specify one or more IPv6 addresses from the range of the subnet to associate with the primary network interface"
  type        = list(string)
  default     = null
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}

variable "launch_template" {
  description = "Specifies a Launch Template to configure the instance. Parameters configured on this resource will override the corresponding parameters in the Launch Template"
  type        = map(string)
  default     = null
}

variable "metadata_options" {
  description = "Customize the metadata options of the instance"
  type        = map(string)
  default     = {}
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  type        = bool
  default     = false
}

variable "network_interface" {
  description = "Customize network interfaces to be attached at instance boot time"
  type        = list(map(string))
  default     = []
}

variable "placement_group" {
  description = "The Placement Group to start the instance in"
  type        = string
  default     = null
}

variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC"
  type        = string
  default     = null
}

variable "root_block_device" {
  description = "Customize details about the root block device of the instance. See Block Devices below for details"
  type        = list(any)
  default     = []
}

variable "secondary_private_ips" {
  description = "A list of secondary private IPv4 addresses to assign to the instance's primary network interface (eth0) in a VPC. Can only be assigned to the primary network interface (eth0) attached at instance creation, not a pre-existing network interface i.e. referenced in a `network_interface block`"
  type        = list(string)
  default     = null
}

variable "source_dest_check" {
  description = "Controls if traffic is routed to the instance when the destination address does not match the instance. Used for NAT or VPNs."
  type        = bool
  default     = true
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "tenancy" {
  description = "The tenancy of the instance (if the instance is running in a VPC). Available values: default, dedicated, host."
  type        = string
  default     = null
}

variable "user_data" {
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument; see user_data_base64 instead."
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "Can be used instead of user_data to pass base64-encoded binary data directly. Use this instead of user_data whenever the value is not a valid UTF-8 string. For example, gzip-encoded user data must be base64-encoded and passed via this argument to avoid corruption."
  type        = string
  default     = null
}

variable "user_data_replace_on_change" {
  description = "When used in combination with user_data or user_data_base64 will trigger a destroy and recreate when set to true. Defaults to false if not set."
  type        = bool
  default     = false
}

variable "volume_tags" {
  description = "A mapping of tags to assign to the devices created by the instance at launch time"
  type        = map(string)
  default     = {}
}

variable "enable_volume_tags" {
  description = "Whether to enable volume tags (if enabled it conflicts with root_block_device tags)"
  type        = bool
  default     = true
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = null
}

variable "timeouts" {
  description = "Define maximum timeout for creating, updating, and deleting EC2 instance resources"
  type        = map(string)
  default     = {}
}

variable "cpu_core_count" {
  description = "Sets the number of CPU cores for an instance." # This option is only supported on creation of instance type that support CPU Options https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-optimize-cpu.html#cpu-options-supported-instances-values
  type        = number
  default     = null
}

variable "cpu_threads_per_core" {
  description = "Sets the number of CPU threads per core for an instance (has no effect unless cpu_core_count is also set)."
  type        = number
  default     = null
}

# Spot instance request
variable "create_spot_instance" {
  description = "Depicts if the instance is a spot instance"
  type        = bool
  default     = false
}

variable "spot_price" {
  description = "The maximum price to request on the spot market. Defaults to on-demand price"
  type        = string
  default     = null
}

variable "spot_wait_for_fulfillment" {
  description = "If set, Terraform will wait for the Spot Request to be fulfilled, and will throw an error if the timeout of 10m is reached"
  type        = bool
  default     = null
}

variable "spot_instance_type" {
  description = "If set to one-time, after the instance is terminated, the spot request will be closed. Default `persistent`"
  type        = string
  default     = "one-time"
}

variable "spot_launch_group" {
  description = "A launch group is a group of spot instances that launch together and terminate together. If left empty instances are launched and terminated individually"
  type        = string
  default     = null
}

variable "spot_block_duration_minutes" {
  description = "The required duration for the Spot instances, in minutes. This value must be a multiple of 60 (60, 120, 180, 240, 300, or 360)"
  type        = number
  default     = null
}

variable "spot_instance_interruption_behavior" {
  description = "Indicates Spot instance behavior when it is interrupted. Valid values are `terminate`, `stop`, or `hibernate`"
  type        = string
  default     = "terminate"
}

variable "spot_valid_until" {
  description = "The end date and time of the request, in UTC RFC3339 format(for example, YYYY-MM-DDTHH:MM:SSZ)"
  type        = string
  default     = null
}

variable "spot_valid_from" {
  description = "The start date and time of the request, in UTC RFC3339 format(for example, YYYY-MM-DDTHH:MM:SSZ)"
  type        = string
  default     = null
}

variable "disable_api_stop" {
  description = "If true, enables EC2 Instance Stop Protection."
  type        = bool
  default     = null

}

################################################################################
# IAM Role / Instance Profile
################################################################################

variable "create_iam_instance_profile" {
  description = "Determines whether an IAM instance profile is created or to use an existing IAM instance profile"
  type        = bool
  default     = false
}

variable "iam_role_name" {
  description = "Name to use on IAM role created"
  type        = string
  default     = null
}

variable "iam_role_use_name_prefix" {
  description = "Determines whether the IAM role name (`iam_role_name` or `name`) is used as a prefix"
  type        = bool
  default     = true
}

variable "iam_role_path" {
  description = "IAM role path"
  type        = string
  default     = null
}

variable "iam_role_description" {
  description = "Description of the role"
  type        = string
  default     = null
}

variable "iam_role_permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the IAM role"
  type        = string
  default     = null
}

variable "iam_role_policies" {
  description = "Policies attached to the IAM role"
  type        = map(string)
  default     = {}
}

variable "iam_role_tags" {
  description = "A map of additional tags to add to the IAM role/profile created"
  type        = map(string)
  default     = {}
}

########################
####     Other      ####
########################