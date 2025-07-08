resource "aws_cloudwatch_log_group" "api_logs" {
  name = "book-recommendation_logsv1"
  retention_in_days = 7
}
