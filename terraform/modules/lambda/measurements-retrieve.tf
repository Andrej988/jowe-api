data "archive_file" "retrieve_measurements_zip" {
  type        = "zip"
  source_file = "./lambdas/measurements/retrieve/index.mjs"
  output_path = "./temp/retrieve_measurements.zip"
}

resource "aws_lambda_function" "retrieve_measurements_lambda" {
  filename      = data.archive_file.retrieve_measurements_zip.output_path
  function_name = var.ENV == "dev" ? "${var.app_name}-api-measurements-retrieve-dev" : "${var.app_name}-api-measurements-retrieve"
  role          = aws_iam_role.jowe_api_lambda_read_only.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.retrieve_measurements_zip.output_base64sha256

  runtime = "nodejs18.x"

  environment {
    variables = {
      TABLE_NAME = var.dynamodb_tables["measurements"]
    }
  }

  tags = {
    Name        = "${var.app_name}-api-measurements-retrieve"
    Environment = var.ENV
    App         = var.app_name
  }

  depends_on = [
    aws_iam_role.jowe_api_lambda_read_only,
    aws_iam_role_policy_attachment.jowe_api_lambda_read_only_AWSLambdaBasicExecutionRole_attachment,
    aws_iam_role_policy_attachment.jowe_api_lambda_dynamodb_read_only_role_attachment_measurements,
  ]
}
