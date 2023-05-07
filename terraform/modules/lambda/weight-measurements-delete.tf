data "archive_file" "weight_measurements_delete_zip" {
  type        = "zip"
  source_dir  = "./lambdas/functions/weight/measurements/delete/"
  output_path = "./temp/weight_measurements_delete.zip"
}

resource "aws_lambda_function" "weight_measurements_delete_lambda" {
  filename      = data.archive_file.weight_measurements_delete_zip.output_path
  function_name = var.ENV == "dev" ? "${var.app_name}-api-weight-measurements-delete-dev" : "${var.app_name}-api-weight-measurements-delete"
  role          = aws_iam_role.jowe_api_lambda_crud.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.weight_measurements_delete_zip.output_base64sha256

  runtime = "nodejs18.x"

  environment {
    variables = {
      TABLE_NAME = var.dynamodb_tables["weight_measurements"]
    }
  }

  layers = [ 
    aws_lambda_layer_version.common_layer.arn,
    aws_lambda_layer_version.weight_measurements_shared_layer.arn,
  ]

  tags = {
    Name        = "${var.app_name}-api-weight-measurements-delete"
    Environment = var.ENV
    App         = var.app_name
  }

  depends_on = [
    aws_iam_role.jowe_api_lambda_crud,
    aws_iam_role_policy_attachment.jowe_api_lambda_crud_AWSLambdaBasicExecutionRole_attachment,
    aws_iam_role_policy_attachment.jowe_api_lambda_dynamodb_crud_role_attachment_measurements,
    aws_lambda_layer_version.weight_measurements_shared_layer,
  ]
}
