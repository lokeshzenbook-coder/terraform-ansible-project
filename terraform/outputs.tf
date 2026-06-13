output "master_public_ip" {
  description = "Public IP of the Ansible master node. Use this to SSH in manually."
  value       = aws_instance.ansible_master.public_ip
}

output "worker_public_ips" {
  description = "Public IPs of all worker nodes. Used by Ansible dynamic inventory."
  value       = aws_instance.worker_nodes[*].public_ip
}

output "master_instance_id" {
  description = "Instance ID of the Ansible master node. Use for AWS Console lookups."
  value       = aws_instance.ansible_master.id
}

output "worker_instance_ids" {
  description = "Instance IDs of all worker nodes."
  value       = aws_instance.worker_nodes[*].id
}

output "security_group_id" {
  description = "ID of the security group applied to all instances."
  value       = aws_security_group.ansible_sg.id
}
