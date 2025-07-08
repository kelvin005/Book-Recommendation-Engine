resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_rolev9"
  assume_role_policy = jsonencode({
  Version = "2012-10-17",
  Statement = [{
    Effect = "Allow",
    Principal = {
      Service = "lambda.amazonaws.com"
    },
    Action = "sts:AssumeRole"
  }]
})
}

resource "aws_iam_role_policy_attachment" "lambda_attachment_policy" {
  role      = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "dynamodb_table_attachment_policy" {
  role      = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess_v2"
}