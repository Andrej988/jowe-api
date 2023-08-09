data "archive_file" "weight_measurements_edit_zip" {
  type        = "zip"
  source_dir  = "${local.lambda_directories["functions_weight_measurements"]}/edit/"
  output_path = "./temp/weight_measurements_edit.zip"
}

resource "aws_cloudwatch_log_group" "weight_measurements_edit_lambda_log_group" {
  name = "${local.cloudwatch_lambdas_log_group_prefix}${local.lambda_function_names["weight_measurements_edit"]}"

  retention_in_days = local.cloudwatch_lambdas_log_retention_in_days

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }
}

resource "aws_lambda_function" "weight_measurements_edit_lambda" {
  filename      = data.archive_file.weight_measurements_edit_zip.output_path
  function_name = local.lambda_function_names["weight_measurements_edit"]
  role          = aws_iam_role.jowe_api_lambda_crud.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.weight_measurements_edit_zip.output_base64sha256
  runtime          = local.lambda_runtimes["nodejs_common_runtime"]

  environment {
    variables = {
      TABLE_NAME = local.lambda_table_names["weight_measurements"]
    }
  }

  layers = [
    aws_lambda_layer_version.common_layer.arn,
    aws_lambda_layer_version.weight_shared_layer.arn,
  ]

  tags = {
    Name        = "${var.app_name}-api-weight-measurements-edit"
    Environment = var.ENV
    App         = var.app_name
  }

  depends_on = [
    aws_iam_role.jowe_api_lambda_crud,
    aws_iam_role_policy_attachment.jowe_api_lambda_crud_AWSLambdaBasicExecutionRole_attachment,
    aws_iam_role_policy_attachment.jowe_api_lambda_dynamodb_crud_role_attachment_weight_measurements,
    aws_lambda_layer_version.common_layer,
    aws_lambda_layer_version.weight_shared_layer,
    aws_cloudwatch_log_group.weight_measurements_edit_lambda_log_group,
  ]
}
