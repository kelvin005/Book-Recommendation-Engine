
provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = "book_recommendations"
}


module "lambda" {
  source   = "./modules/lambda"
  dynamodb_table_name  = module.dynamodb.dynamodb_table_name
  lambda_exec_role     = module.iam_role.lambda_role_arn
}
module "api_gateway" {
  source = "./modules/api_gateway"

  lambda_name = module.lambda.lambda_name
  lambda_arn  = module.lambda.lambda_invoke_arn
  log_group_arn = module.cloudwatch.cloudwatch_log_group_arn

  depends_on = [
    module.lambda
  ]
}

module "s3_frontend" {
  source = "./modules/s3_frontend"
  bucket_name = "book-recommendation-frontendv2"
  local_dir   = "${path.module}/../frontend"
}
module "cloudwatch" {
  source = "./modules/cloudwatch"
}
module "iam_role" {
  source = "./modules/iam_role"
}


output "api_endpoint_root_url" {
  value = module.api_gateway.api_endpoint
}

