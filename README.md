# Terraform InfluxDB Module

Builds out all infrastructure for running InfluxDB community and enterprise on AWS.

This module allows for easily starting with OSS and scaling out to enterprise as you scale your monitoring and analytics platform.

## Usage

This module intentionally leaves host level provisioning and configuration management tasks up to the consumer.

Official Ansible modules can be found here: https://galaxy.ansible.com/influxdata/influxdb-enterprise/


### Single Enterprise Cluster

```
Module "influxdb" {
    source  = "influxdata/influxdb/aws"
    version = "1.0.0"

    data_instances    = 4
    # Set meta-instances to zero for OSS usage :)
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

### Influx Enterprise Multi-Cluster Configuration

A "name" variable can be specified when running multiple clusters in the same site.

```
module "influxdb" {
    source  = "influxdata/influxdb/aws"
    version = "1.0.0"

    name              = "influx01"
    data_instances    = 4
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

module "influxdb" {
    source  = "influxdata/influxdb/aws"
    version = "1.0.0"

    name              = "influx02"
    data_instances    = 4
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
