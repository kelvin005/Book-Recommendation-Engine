variable "lambda_arn" {
  type = string
}
variable "lambda_name" {
  type = string
}
variable "log_group_arn" {
  type = string
  default = ""  # optional, unless you define logs
}
