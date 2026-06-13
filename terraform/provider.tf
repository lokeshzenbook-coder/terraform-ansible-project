terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source = "hashicorp/aws"

      # FIX: ~> 6.0 does not exist. Current stable major is 5.x.
      # Using ~> 5.0 allows any 5.x patch/minor update but blocks 6.x
      # until you explicitly upgrade and test breaking changes.
      version = "~> 5.0"
    }
  }

  # FIX: Without a backend, state is stored on the CI runner's local disk.
  # The runner is ephemeral — state is lost after every job, so the next
  # terraform apply sees no existing state and tries to create duplicate
  # resources, causing errors or unexpected infrastructure.
  #
  # Steps to enable:
  #   1. Create the S3 bucket and DynamoDB table (once, manually or via bootstrap):
  #        aws s3api create-bucket --bucket terraform-ansible-state-<yourname> --region us-east-1
  #        aws dynamodb create-table \
  #          --table-name terraform-state-lock \
  #          --attribute-definitions AttributeName=LockID,AttributeType=S \
  #          --key-schema AttributeName=LockID,KeyType=HASH \
  #          --billing-mode PAY_PER_REQUEST
  #   2. Uncomment the backend block below.
  #   3. Run `terraform init` to migrate existing state into S3.

  # backend "s3" {
  #   bucket         = "terraform-ansible-state-<yourname>"
  #   key            = "envs/dev/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "terraform-state-lock"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region

  # FIX: Use provider-level default_tags instead of repeating tags on every
  # resource block. These merge with any resource-level tags automatically.
  default_tags {
    tags = {
      Project     = "terraform-ansible"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}
