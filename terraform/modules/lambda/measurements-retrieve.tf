data "archive_file" "retrieve_measurements_zip" {
  type        = "zip"
  source_file = "./lambda/measurements/retrieve/index.mjs"
  output_path = "./temp/retrieve_measurements.zip"
}

resource "aws_lambda_function" "retrieve_measurements_lambda" {
  filename      = data.archive_file.retrieve_measurements_zip.output_path
  function_name = var.ENV == "dev" ? "weight-tracker-api-measurements-retrieve-dev" : "weight-tracker-api-measurements-retrieve"
  role          = aws_iam_role.weight_tracker_api_lambda_read_only.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.retrieve_measurements_zip.output_base64sha256

  runtime = "nodejs18.x"

  tags = {
    Name        = "weight-tracker-api-measurements-retrieve"
    Environment = var.ENV
    App         = var.app_name
  }

  depends_on = [
    aws_iam_role.weight_tracker_api_lambda_read_only,
    aws_iam_role_policy_attachment.weight_tracker_api_lambda_read_only_AWSLambdaBasicExecutionRole_attachment,
    aws_iam_role_policy_attachment.weight_tracker_api_lambda_read_only_dynamodb_role_attachment,
  ]
}
