# ─────────────────────────────────────────────
# Data sources
# ─────────────────────────────────────────────
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }

  # FIX: Explicitly pin architecture to x86_64.
  # Without this, the latest AMI could resolve to an arm64 image,
  # which fails to launch on t2.micro (x86_64 only).
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# ─────────────────────────────────────────────
# Security group
# ─────────────────────────────────────────────
resource "aws_security_group" "ansible_sg" {
  name_prefix = "ansible-sg-"
  description = "Security group for Ansible master and worker nodes"

  # FIX: Restrict SSH to a known CIDR via variable instead of 0.0.0.0/0.
  # Exposing port 22 to the internet is a critical security risk.
  # Set var.allowed_ssh_cidr to your CI runner IP or your office IP.
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "ansible-sg"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# ─────────────────────────────────────────────
# Ansible master node
# ─────────────────────────────────────────────
resource "aws_instance" "ansible_master" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.ansible_sg.id]

  # FIX: Explicitly assign a public IP.
  # In non-default VPCs this is not automatic — without it,
  # Ansible has no address to SSH into.
  associate_public_ip_address = true

  tags = {
    Name        = "ansible-master"
    Role        = "master"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

# ─────────────────────────────────────────────
# Worker nodes
# ─────────────────────────────────────────────
resource "aws_instance" "worker_nodes" {
  # FIX: Use a variable instead of hardcoded 4.
  # Change worker count in terraform.tfvars without touching main.tf.
  count = var.worker_count

  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids      = [aws_security_group.ansible_sg.id]
  associate_public_ip_address = true

  tags = {
    Name        = "worker-${count.index + 1}"
    Role        = "worker"
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}
