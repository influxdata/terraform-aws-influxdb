output "meta_nodes_ids" {
  value = ["${aws_instance.meta_node.*.id}"]
}

output "data_node_ids" {
  value = ["${aws_instance.data_node.*.id}"]
}

output "data_node_count" {
  value = "${var.data_instances}"
}
