data "archive_file" "retrieve_measurements_zip" {
  type        = "zip"
  source_file = "./lambdas/measurements/retrieve/index.mjs"
  output_path = "./temp/retrieve_measurements.zip"
}

resource "aws_lambda_function" "retrieve_measurements_lambda" {
  filename      = data.archive_file.retrieve_measurements_zip.output_path
  function_name = var.ENV == "dev" ? "health-tracker-api-measurements-retrieve-dev" : "health-tracker-api-measurements-retrieve"
  role          = aws_iam_role.health_tracker_api_lambda_read_only.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.retrieve_measurements_zip.output_base64sha256

  runtime = "nodejs18.x"

  environment {
    variables = {
      TABLE_NAME = dynamodb_tables["measurements"]
    }
  }

  tags = {
    Name        = "health-tracker-api-measurements-retrieve"
    Environment = var.ENV
    App         = var.app_name
  }

  depends_on = [
    aws_iam_role.health_tracker_api_lambda_read_only,
    aws_iam_role_policy_attachment.health_tracker_api_lambda_read_only_AWSLambdaBasicExecutionRole_attachment,
    aws_iam_role_policy_attachment.health_tracker_api_lambda_dynamodb_read_only_role_attachment_measurements,
  ]
}
