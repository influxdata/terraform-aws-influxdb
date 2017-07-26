resource "aws_instance" "data_node" {
    ami                         = "${var.ami}"
    instance_type               = "${var.instance_type}"
    tags                        = "${merge(var.tags, map("Name", "${var.name}-data${format("%02d", count.index + 1)}"), map("Role", "${replace(var.name, "-", "_")}_data"), map("Type", "data"))}"
    subnet_id                   = "${element(var.subnet_ids, count.index)}"
    key_name                    = "${var.key_name}"
    user_data                   = "${var.user_data == "" ? file("${path.module}/files/init.sh") : var.user_data }"
    ebs_optimized               = true
    vpc_security_group_ids      = ["${concat(list(aws_security_group.influx_cluster.id, aws_security_group.data_node.id), var.security_groups)}"]
    count                       = "${var.data_instances}"
}

resource "aws_ebs_volume" "data" {
    size              = "${var.data_disk_size}"
    encrypted         = true
    type              = "io1"
    iops              = "${var.data_disk_iops}"
    availability_zone = "${element(aws_instance.data_node.*.availability_zone, count.index)}"
    tags              = "${var.tags}"
    count             = "${var.data_instances}"
}

resource "aws_volume_attachment" "data_attachment" {
    device_name = "${var.data_disk_device_name}"
    volume_id   = "${element(aws_ebs_volume.data.*.id, count.index)}"
    instance_id = "${element(aws_instance.data_node.*.id, count.index)}"
    count       = "${var.data_instances}"
    force_detach = true
}

resource "aws_instance" "meta_node" {
    ami                         = "${var.ami}"
    instance_type               = "t2.medium"
    tags                        = "${merge(var.tags, map("Name", "${var.name}-meta${format("%02d", count.index + 1)}"), map("Role", "${replace(var.name, "-", "_")}_meta"), map("Type", "data"))}"
    subnet_id                   = "${element(var.subnet_ids,0)}"
    key_name                    = "${var.key_name}"
    user_data                   = "${var.user_data == "" ? file("${path.module}/files/init.sh") : var.user_data }"
    vpc_security_group_ids      = ["${concat(list(aws_security_group.influx_cluster.id), var.security_groups)}"]
    count                       = "${var.meta_instances}"
}

resource "aws_route53_record" "meta_node" {
    zone_id = "${var.zone_id}"
    name    = "${var.name}-meta${format("%02d", count.index + 1)}"
    type    = "A"
    ttl     = "120"
    records = ["${element(aws_instance.meta_node.*.private_ip, count.index)}"]
    count   = "${var.meta_instances}"
}

resource "aws_route53_record" "data_node" {
    zone_id = "${var.zone_id}"
    name    = "${var.name}-data${format("%02d", count.index + 1)}"
    type    = "A"
    ttl     = "120"
    records = ["${element(aws_instance.data_node.*.private_ip, count.index)}"]
    count   = "${var.data_instances}"
}


resource "aws_security_group" "influx_cluster" {
    name        = "${var.name}_cluster"
    description = "Rules required for an Influx Enterprise Cluster"
    tags        = "${merge(var.tags, map("Name", "${var.name}"), map("Role", "influx"))}"
    vpc_id      = "${var.vpc_id}"
}

resource "aws_security_group_rule" "cluster_comms" {
  type              = "ingress"
  from_port         = 8088
  to_port           = 8091
  protocol          = "tcp"
  cidr_blocks       = ["${formatlist("%s/32", concat(aws_instance.meta_node.*.private_ip, aws_instance.data_node.*.private_ip))}"]
  security_group_id = "${aws_security_group.influx_cluster.id}"
}

resource "aws_security_group_rule" "outbound" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.influx_cluster.id}"
}

resource "aws_security_group" "data_node" {
    description = "Security group for influx data node ingress"
    vpc_id      = "${var.vpc_id}"
    tags        = "${merge(var.tags, map("Name", "${var.name}"), map("Role", "influx"))}"

    ingress {
        from_port   = "8086"
        to_port     = "8086"
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
