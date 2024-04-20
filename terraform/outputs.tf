# Output public IP addresses
output "control_node_public_ip" {
  value = aws_instance.control_node.public_ip
}

output "managed_app_node_public_ip" {
  value = aws_instance.managed_app_node.public_ip
}

output "managed_db_node_public_ip" {
  value = aws_instance.managed_db_node.public_ip
}
