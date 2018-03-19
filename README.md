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
module "influxdb" {
    source  = "influxdata/influxdb/aws"
    version = "1.0.0"

    data_instances    = 4
    data_disk_size    = 500
    data_disk_iops    = 6000
    meta_instances    = 3
    ami               = "ami-6d48500b"
    tags              = "${map("Environment", "production")}"
    subnet_ids        = "${list("subnet-9d4a7b6c", "subnet-7d4a9b6c")}"
    vpc_id            = "vpc-6589ba03"
    instance_type     = "m4.large"
    key_name          = "deployer"
    zone_id           = "Z4RIKDGDIXUWGT"
    security_groups   = "${list("sg-fffa2187")}"
}
```
