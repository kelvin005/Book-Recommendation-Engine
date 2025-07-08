resource "aws_dynamodb_table" "book_cache" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "genre"

  attribute {
    name = "genre"
    type = "S"
  }

  tags = {
    Project = "BookRecommendationEngine"
  }
}
