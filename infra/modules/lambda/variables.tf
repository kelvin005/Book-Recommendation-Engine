variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table to query"
  type        = string
}
variable "lambda_exec_role" {
  description = "ARN of the IAM role for Lambda execution"
  type        = string
}
