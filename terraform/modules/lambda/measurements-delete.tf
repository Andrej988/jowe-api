data "archive_file" "delete_measurement_zip" {
  type        = "zip"
  source_file = "./lambda/measurements/delete/index.mjs"
  output_path = "./temp/delete_measurement.zip"
}

resource "aws_lambda_function" "delete_measurement_lambda" {
  filename      = data.archive_file.delete_measurement_zip.output_path
  function_name = "weight-tracker-api-measurements-delete"
  role          = aws_iam_role.weight_tracker_api_lambda_crud.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.delete_measurement_zip.output_base64sha256

  runtime = "nodejs18.x"

  tags = {
    Name        = "weight-tracker-api-measurements-delete"
    Environment = var.ENV
    App         = var.app_name
  }

  depends_on = [
    aws_iam_role.weight_tracker_api_lambda_crud,
    aws_iam_role_policy_attachment.weight_tracker_api_lambda_crud_AWSLambdaBasicExecutionRole_attachment,
    aws_iam_role_policy_attachment.weight_tracker_api_lambda_crud_dynamodb_role_attachment,
  ]
}
