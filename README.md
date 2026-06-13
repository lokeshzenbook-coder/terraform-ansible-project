Terraform + Ansible + GitHub Actions Project
Objective
Provision infrastructure using Terraform:

1 Ansible Master EC2
4 Worker EC2 Instances
Configure servers using Ansible:

Install Nginx
Install Python3
Enable Nginx Service
Automate everything using GitHub Actions.

Workflow
Developer Push ↓ GitHub Actions ↓ Terraform Apply ↓ AWS EC2 Creation ↓ Dynamic Inventory Generation ↓ Ansible Playbook Execution ↓ Nginx + Python Installed

Tools Used
AWS EC2
Terraform
Ansible
GitHub Actions
Linux
SSH
Deployment
git clone <repo>

terraform init

terraform apply
Verify
ansible all -m ping

ansible-playbook playbook.yml
Visit:

http://<worker-public-ip>
You should see the Nginx welcome page.
