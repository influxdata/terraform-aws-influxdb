# Terraform InfluxDB Module

Builds out all infrastructure for running InfluxDB OSS instances and InfluxDB Enterprise clusters using Terraform. OSS support particuarly useful for those want to start with OSS and scale out to enterprise installations.

Currently only the AWS provider is supported; However all enhancements are welome!

## Usage

This module intentionally leaves operating system level provisioning and configuration management up to the user.

### Single Enterprise Cluster

```
module "influxdb" {
    source             = "github.com/influxdata/terraform-influxdb"

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

### Two Enterprise Clusters

A "name" variable can be specified when running multiple clusters in the same site.

```
module "influxdb" {
    source             = "github.com/influxdata/terraform-influxdb"

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
    source             = "github.com/influxdata/terraform-influxdb"

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
