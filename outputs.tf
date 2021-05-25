output "meta_nodes_ids" {
  description = "A list of all meta node instance ids"
  value = ["${aws_instance.meta_node.*.id}"]
}

output "data_node_ids" {
  description = "A list of all data node instance ids"
  value = ["${aws_instance.data_node.*.id}"]
}

output "data_node_count" {
  description = "Yields the data node count, this can be used in conjunction with modules that configure load balancers etc"
  value = var.data_instances
}
