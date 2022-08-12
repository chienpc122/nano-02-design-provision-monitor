terraform {
  required_version = "> 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "archive" {
}

data "archive_file" "zip_source" {
  type        = "zip"
  source_file = "lambda.py"
  output_path = "lambda.zip"
}

resource "aws_iam_role" "udacity_role_for_lambda" {
  name = "udacity_role_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "udacity_lambda_policy" {
  name        = "udacity_lambda_policy"
  path        = "/"
  description = "IAM policy for lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role        = aws_iam_role.udacity_role_for_lambda.name
  policy_arn  = aws_iam_policy.udacity_lambda_policy.arn
}

resource "aws_lambda_function" "lambda" {
  function_name = "udacity_hello_world"
  filename         = data.archive_file.zip_source.output_path
  source_code_hash = data.archive_file.zip_source.output_base64sha256
  role    = aws_iam_role.udacity_role_for_lambda.arn
  handler = "lambda.hello_world"
  runtime = "python3.9"
  depends_on  = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}