resource "aws_apigatewayv2_api" "http_api" {
  name          = "book-recommendation-apiv1"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins     = ["*"]
    allow_methods     = ["GET", "OPTIONS"]
    allow_headers     = ["*"]
    expose_headers    = []
    max_age           = 3600
    allow_credentials = false
  }
}


resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id             = aws_apigatewayv2_api.http_api.id
  integration_type   = "AWS_PROXY"
  integration_uri    = var.lambda_arn
  integration_method = "POST"
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "recommend_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "GET /recommend"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_lambda_permission" "api_gateway_invoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
  default_route_settings {
    throttling_burst_limit = 100
    throttling_rate_limit  = 50
  }
  access_log_settings {
    destination_arn = var.log_group_arn
    format = jsonencode({
      requestId     = "$context.requestId",
      httpMethod    = "$context.httpMethod",
      path          = "$context.path",
      status        = "$context.status"
    })
  }
}

