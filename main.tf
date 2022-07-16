# creating remote state management resources in the same region you plan to use for CICD resources
locals {
    namespace = "org-citypals-tf-state"
    environment_list = ["dev", "qa"]
}

# we use the cloudposse 3rd party module to create s3 buckets and DynamoDB tables for state locking
module "terraform_state_backend" {
    for_each = toset(local.environment_list)
    source = "github.com/cloudposse/terraform-aws-tfstate-backend?ref=0.38.1"
    namespace = local.namespace
    stage = each.key
    dynamodb_table_name = "${local.namespace} -lock-${each.key}"
    terraform_backend_config_file_path = "."
    terraform_backend_config_file_name = "backend.tf"
    force_destroy                      = false
}

provider "aws" {
    region = "eu-west-3"
  
}