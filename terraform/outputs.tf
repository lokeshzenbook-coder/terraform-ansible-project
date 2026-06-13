output "master_ip" {
  value = aws_instance.ansible_master.public_ip
}

output "worker_ips" {
  value = aws_instance.worker_nodes[*].public_ip
}
