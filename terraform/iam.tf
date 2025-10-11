data "aws_iam_policy_document" "lambda_assume_role" {
statement {
actions = ["sts:AssumeRole"]
principals {
type = "Service"
identifiers = ["lambda.amazonaws.com"]
}
}
}


resource "aws_iam_role" "lambda_exec_role" {
name = "${var.lambda_function_name}-exec-role"
assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}


resource "aws_iam_role_policy" "lambda_dynamodb_policy" {
name = "${var.lambda_function_name}-dynamodb-policy"
role = aws_iam_role.lambda_exec_role.id


policy = jsonencode({
Version = "2012-10-17"
Statement = [
{
Effect = "Allow"
Action = [
"dynamodb:PutItem",
"dynamodb:GetItem",
"dynamodb:Scan",
"dynamodb:UpdateItem",
"dynamodb:DeleteItem"
]
Resource = aws_dynamodb_table.notes.arn
},
{
Effect = "Allow"
Action = [
"logs:CreateLogGroup",
"logs:CreateLogStream",
"logs:PutLogEvents"
]
Resource = "arn:aws:logs:*:*:*"
}
]
})
}


# keep the AWS-managed basic execution role attached as well (optional)
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
role = aws_iam_role.lambda_exec_role.name
policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}