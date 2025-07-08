

resource "aws_lambda_function" "lambda_function" {
  filename         = "${path.module}/lambda.zip"
  function_name    = "book_recommendervv5"
  role             = var.lambda_exec_role
  handler          = "handler.handler"
  runtime          = "python3.10"
  source_code_hash = filebase64sha256("${path.module}/lambda.zip")

  environment {
    variables = {
      TABLE_NAME = var.dynamodb_table_name

    }
  }
}

