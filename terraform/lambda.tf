# Build the lambda package locally using a null_resource -> scripts/build_lambda.sh
resource "null_resource" "package_lambda" {
provisioner "local-exec" {
command = "bash ${path.module}/scripts/build_lambda.sh"
working_dir = path.module
}
}


resource "aws_lambda_function" "notes_lambda" {
function_name = var.lambda_function_name
runtime = "python3.11"
handler = "lambda_function.lambda_handler"
role = aws_iam_role.lambda_exec_role.arn
filename = "${path.module}/build/lambda.zip"
source_code_hash = filebase64sha256("${path.module}/build/lambda.zip")


environment {
variables = {
TABLE_NAME = aws_dynamodb_table.notes.name
REGION = var.aws_region
}
}


depends_on = [null_resource.package_lambda]

  # Ignore source_code_hash changes to prevent CI apply errors
  lifecycle {
    ignore_changes = [
      source_code_hash
    ]
  }

}