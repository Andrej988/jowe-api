data "archive_file" "weight_targets_delete_zip" {
  type        = "zip"
  source_dir  = "${local.lambda_directories["functions_weight_targets"]}/delete/"
  output_path = "./temp/weight_targets_delete.zip"
}

resource "aws_cloudwatch_log_group" "weight_targets_delete_lambda_log_group" {
  name = "${local.cloudwatch_lambdas_log_group_prefix}${local.lambda_function_names["weight_targets_delete"]}"

  retention_in_days = local.cloudwatch_lambdas_log_retention_in_days

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }
}

resource "aws_lambda_function" "weight_targets_delete_lambda" {
  filename      = data.archive_file.weight_targets_delete_zip.output_path
  function_name = local.lambda_function_names["weight_targets_delete"]
  role          = aws_iam_role.jowe_api_lambda_crud.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.weight_targets_delete_zip.output_base64sha256
  runtime          = local.lambda_runtimes["nodejs_common_runtime"]

  environment {
    variables = {
      TABLE_NAME = local.lambda_table_names["weight_targets"]
    }
  }

  layers = [
    aws_lambda_layer_version.common_layer.arn,
    aws_lambda_layer_version.weight_shared_layer.arn,
  ]

  tags = {
    Name        = "${var.APP_NAME}-api-weight-targets-delete"
    Environment = var.ENV
    App         = var.APP_NAME
  }

  depends_on = [
    aws_iam_role.jowe_api_lambda_crud,
    aws_iam_role_policy_attachment.jowe_api_lambda_crud_AWSLambdaBasicExecutionRole_attachment,
    aws_iam_role_policy_attachment.jowe_api_lambda_dynamodb_crud_role_attachment_weight_targets,
    aws_lambda_layer_version.weight_shared_layer,
    aws_cloudwatch_log_group.weight_targets_delete_lambda_log_group,
  ]
}
