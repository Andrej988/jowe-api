data "archive_file" "weight_measurements_insert_zip" {
  type        = "zip"
  source_dir  = "${local.weight_measurements_lambdas_directory}/insert/"
  output_path = "./temp/weight_measurements_insert.zip"
}

resource "aws_cloudwatch_log_group" "weight_measurements_insert_lambda_log_group" {
  name = "${local.cloudwatch_lambdas_log_group_prefix}${local.weight_measurements_insert_lambda_name}"

  retention_in_days = local.cloudwatch_lambdas_log_retention_in_days

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }
}

resource "aws_lambda_function" "weight_measurements_insert_lambda" {
  filename      = data.archive_file.weight_measurements_insert_zip.output_path
  function_name = local.weight_measurements_insert_lambda_name
  role          = aws_iam_role.jowe_api_lambda_crud.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.weight_measurements_insert_zip.output_base64sha256
  runtime          = local.lambdas_common_runtime

  environment {
    variables = {
      TABLE_NAME = local.weight_measurements_table_name
    }
  }

  layers = [
    aws_lambda_layer_version.common_layer.arn,
    aws_lambda_layer_version.weight_measurements_shared_layer.arn,
  ]

  tags = {
    Name        = "${var.app_name}-api-weight-measurements-insert"
    Environment = var.ENV
    App         = var.app_name
  }

  depends_on = [
    aws_iam_role.jowe_api_lambda_crud,
    aws_iam_role_policy_attachment.jowe_api_lambda_crud_AWSLambdaBasicExecutionRole_attachment,
    aws_iam_role_policy_attachment.jowe_api_lambda_dynamodb_crud_role_attachment_measurements,
    aws_lambda_layer_version.common_layer,
    aws_lambda_layer_version.weight_measurements_shared_layer,
    aws_cloudwatch_log_group.weight_measurements_insert_lambda_log_group,
  ]
}
