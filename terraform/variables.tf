variable "aws_region" {
description = "AWS region"
type = string
default = "ap-south-1"
}


variable "lambda_function_name" {
type = string
default = "notes-api-lambda"
}


variable "dynamodb_table_name" {
type = string
default = "NotesTable"
}