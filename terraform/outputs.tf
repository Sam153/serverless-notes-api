output "api_endpoint" {
description = "Base API endpoint"
value = aws_apigatewayv2_api.http_api.api_endpoint
}


output "notes_url" {
description = "Notes URL (GET/POST)"
value = "${aws_apigatewayv2_api.http_api.api_endpoint}/notes"
}