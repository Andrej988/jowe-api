data "archive_file" "weight_targets_delete_user_data_zip" {
  type        = "zip"
  source_dir  = "${local.lambda_directories["functions_weight_targets"]}/deleteUserData/"
  output_path = "./temp/weight_targets_delete_user_data.zip"
}

resource "aws_cloudwatch_log_group" "weight_targets_delete_user_data_lambda_log_group" {
  name = "${local.cloudwatch_lambdas_log_group_prefix}${local.lambda_function_names["weight_targets_delete_user_data"]}"

  retention_in_days = local.cloudwatch_lambdas_log_retention_in_days

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }
}

resource "aws_lambda_function" "weight_targets_delete_user_data_lambda" {
  filename      = data.archive_file.weight_targets_delete_user_data_zip.output_path
  function_name = local.lambda_function_names["weight_targets_delete_user_data"]
  role          = aws_iam_role.jowe_api_lambda_crud.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.weight_targets_delete_user_data_zip.output_base64sha256
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
    Name        = "${var.app_name}-api-weight-targets-delete"
    Environment = var.ENV
    App         = var.app_name
  }

  depends_on = [
    aws_iam_role.jowe_api_lambda_crud,
    aws_iam_role_policy_attachment.jowe_api_lambda_crud_AWSLambdaBasicExecutionRole_attachment,
    aws_iam_role_policy_attachment.jowe_api_lambda_dynamodb_crud_role_attachment_weight_targets,
    aws_iam_role_policy_attachment.jowe_api_lambda_sqs_processing_weight_targets_delete_user_data_role_attachment,
    aws_lambda_layer_version.weight_shared_layer,
    aws_cloudwatch_log_group.weight_targets_delete_lambda_log_group,
  ]
}

resource "aws_lambda_event_source_mapping" "sqs_lambda_event_source_mapping_weight_targets_delete_user_data" {
  event_source_arn                   = var.sns_and_sqs_arns["sqs_weight_targets_delete_user_data_queue"]
  enabled                            = true
  function_name                      = aws_lambda_function.weight_targets_delete_user_data_lambda.arn
  batch_size                         = local.lambda_sqs_event_store_batch_size
  maximum_batching_window_in_seconds = local.lambda_sqs_event_store_batching_window
  maximum_retry_attempts             = local.lambda_sqs_event_store_retry_attempts
}

