resource "aws_apigatewayv2_api" "http_api" {
name = "notes-http-api"
protocol_type = "HTTP"


cors_configuration {
allow_methods = ["GET", "POST", "OPTIONS"]
allow_headers = ["*"]
allow_origins = ["*"]
}
}


resource "aws_apigatewayv2_integration" "lambda_integration" {
api_id = aws_apigatewayv2_api.http_api.id
integration_type = "AWS_PROXY"
integration_uri = aws_lambda_function.notes_lambda.invoke_arn
integration_method = "POST"
payload_format_version = "2.0"
}


resource "aws_apigatewayv2_route" "route" {
api_id = aws_apigatewayv2_api.http_api.id
route_key = "ANY /notes"
target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}


resource "aws_apigatewayv2_stage" "default" {
api_id = aws_apigatewayv2_api.http_api.id
name = "$default"
auto_deploy = true
}


resource "aws_lambda_permission" "apigw_invoke" {
statement_id = "AllowAPIGatewayInvoke"
action = "lambda:InvokeFunction"
function_name = aws_lambda_function.notes_lambda.function_name
principal = "apigateway.amazonaws.com"
source_arn = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}