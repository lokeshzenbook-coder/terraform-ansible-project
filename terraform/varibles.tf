variable "worker_count" {
  description = "Number of Ansible worker nodes to provision"
  type        = number
  default     = 4
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to SSH into instances. Restrict to your IP in production."
  type        = string
  default     = "0.0.0.0/0"  # override in terraform.tfvars
}

variable "environment" {
  description = "Environment label applied as a tag to all resources"
  type        = string
  default     = "dev"
}
