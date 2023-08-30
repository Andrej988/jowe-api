data "archive_file" "list_values_retrieve_zip" {
  type        = "zip"
  source_dir  = "${local.lambda_directories["functions_list_values"]}/retrieve/"
  output_path = "./temp/list_values_retrieve.zip"
}

resource "aws_cloudwatch_log_group" "list_values_retrieve_lambda_log_group" {
  name = "${local.cloudwatch_lambdas_log_group_prefix}${local.lambda_function_names["list_values_retrieve"]}"

  retention_in_days = local.cloudwatch_lambdas_log_retention_in_days

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }
}

resource "aws_lambda_function" "list_values_retrieve_lambda" {
  filename      = data.archive_file.list_values_retrieve_zip.output_path
  function_name = local.lambda_function_names["list_values_retrieve"]
  role          = aws_iam_role.jowe_api_lambda_read_only.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.list_values_retrieve_zip.output_base64sha256
  runtime          = local.lambda_runtimes["nodejs_common_runtime"]

  environment {
    variables = {
      TABLE_NAME = local.lambda_table_names["list_values"]
    }
  }

  layers = [
    aws_lambda_layer_version.common_layer.arn,
    aws_lambda_layer_version.masterdata_shared_layer.arn,
  ]

  tags = {
    Name        = "${var.APP_NAME}-api-list-values-retrieve"
    Environment = var.ENV
    App         = var.APP_NAME
  }

  depends_on = [
    aws_iam_role.jowe_api_lambda_read_only,
    aws_iam_role_policy_attachment.jowe_api_lambda_read_only_AWSLambdaBasicExecutionRole_attachment,
    aws_iam_role_policy_attachment.jowe_api_lambda_dynamodb_read_only_role_attachment_list_values,
    aws_lambda_layer_version.masterdata_shared_layer,
    aws_cloudwatch_log_group.list_values_retrieve_lambda_log_group,
  ]
}
