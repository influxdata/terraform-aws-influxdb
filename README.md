# Terraform InfluxDB Module

Terraform module for deploying Influx OSS and Enterprise to AWS EC2.

This module creates and manages the following resources:

* Meta and Data node instances including associated EBS volumes.
* Security groups for cluster communications.
* Route53 Records for instances in a specified zone.
* Optional tagging of all resources for easy identification of resources. Useful with third-party configuration management tooling.

For the sake of deployment flexibility, this module intentionally leaves host level provisioning up to the user. For example users may like to use Ansible, Puppet or Chef to complete the installation procedure. A default AMI is not specified and should to be provided by the user.

Optional tags can be specified making this module easy to use with third-party configuration management systems as outlined in this [Ansible guide](http://docs.ansible.com/ansible/latest/intro_dynamic_inventory.html#example-aws-ec2-external-inventory-script)

## Usage Example

The following example demonstrates deploying a single Influx Enterprise cluster to production. This configuration will deploy 4 data nodes, 3 meta nodes, tagging all resources with an "Environment" tag set to _production_.

See the inputs doc or variable definitions file for more configuration options.

```
provider "aws" {
  region     = "us-east-2"
  access_key = "your-access-key"
  secret_key = "your-secret-key"

module "influxdb" {
    source  = "influxdata/influxdb/aws"
    version = "1.0.6"

    data_instances    = 2
    data_disk_size    = 500
    data_disk_iops    = 1000
    meta_instances    = 3
    ami               = "ami-0f42acddbf04bd1b6"
    subnet_id         = "subnet-8d5c5643"
    vpc_id            = "vpc-b535e44g"
    instance_type     = "m4.large"
    key_name          = "ignacio"
    zone_id           = "Z044144236NI0U6A5435435"
    security_group    = ["sg-0c8dc3456"]
}    
```
