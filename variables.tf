variable "availabity_zone" {
  description = "Insert the Availability Zone according to your Subnet and PVC"
  default = "us-east-2b"
}

variable "name" {
  description = "The prefix that will be applied to resources managed by this module"
  default     = "influxdb"
}
variable "ami" {
  description = "The AMI ID to deploy"
  default = "ami-0f42acddbf04bd1b6"
}

variable "data_instances" {
  description = "The number of data nodes to run"
  default = 2
}

variable "meta_instances" {
  description = "The number of meta nodes to run"
  default = 3
}

variable "subnet_id" {
  description = "The subnet ID for servers, data-nodes will be equally distributed accross these subnets"
  default = ""
}

variable "instance_type" {
  description = "The AWS Instance type. For example, m2.large"
  default = "m4.large"
}

variable "vpc_id" {
  description = "VPC ID for instances and security groups"
  default = ""
}

variable "key_name" {
  description = "Key name for new hosts"
  default = ""
}

variable "zone_id" {
  description = "The private DNS zone to create records for hosts"
  default = ""
}

variable "data_disk_size" {
  description = "The size of the data disks to provision, for data nodes only"
  default     = 300
}

variable "data_disk_iops" {
  description = "The number of IOPs for the io1 type volume"
  default     = 4000
}

variable "security_group" {
  description = "Extra security groups to apply to all hosts, useful for bastion host access"
  default     = [""]
}

variable "user_data" {
  description = "User data script for all instances"
  default     = ""
}

variable "data_disk_device_name" {
  description = "The name of the device to attach to the data-nodes"
  default     = "/dev/xvdh"
}

variable "meta_disk_device_name" {
  description = "The name of the device to attach to the meta-nodes"
  default     = "/dev/xvdh"
}
