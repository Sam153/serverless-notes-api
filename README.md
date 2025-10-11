# Serverless Notes API (Terraform)
# Added to trigger to CI pipeline

Simple Notes CRUD API (Create + Read) implemented as a serverless stack:
- AWS Lambda (Python)
- API Gateway (HTTP API)
- DynamoDB (on-demand)


## Quick start (local)


Prereqs:
- AWS account with permissions to create IAM, Lambda, API Gateway, DynamoDB
- AWS CLI configured (or set `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` env vars)
- Terraform >= 1.0


Steps:
```bash
# 1. cd into terraform
cd terraform


# 2. (optional) check/modify variables in variables.tf


# 3. Initialize terraform
terraform init


# 4. Apply
terraform apply -auto-approve


# 5. Get the public endpoint
terraform output -raw notes_url
# Example output: https://abcd123.execute-api.ap-south-1.amazonaws.com/notes


# 6. Test
curl -X POST "$NOTES_URL" -H "Content-Type: application/json" -d '{"id":"1","note":"hello"}'
curl "$NOTES_URL"
