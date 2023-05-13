data "archive_file" "common_delete_user_data_zip" {
  type        = "zip"
  source_dir  = "${local.lambda_directories["functions_common"]}/deleteUserData/build/"
  output_path = "./temp/common_delete_user_data.zip"
}

resource "aws_cloudwatch_log_group" "common_delete_user_data_lambda_log_group" {
  name = "${local.cloudwatch_lambdas_log_group_prefix}${local.lambda_function_names["common_delete_user_data"]}"

  retention_in_days = local.cloudwatch_lambdas_log_retention_in_days

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }
}

resource "aws_lambda_function" "common_delete_user_data_lambda" {
  filename      = data.archive_file.common_delete_user_data_zip.output_path
  function_name = local.lambda_function_names["common_delete_user_data"]
  role          = aws_iam_role.jowe_api_lambda_sns.arn
  handler       = "main"

  source_code_hash = data.archive_file.common_delete_user_data_zip.output_base64sha256
  runtime          = local.lambda_runtimes["golang_common_runtime"]

  environment {
    variables = {
      TOPIC_ARN = var.sns_and_sqs_arns["sns_delete_user_data_topic"]
    }
  }

  tags = {
    Name        = "${var.app_name}-api-common-delete-user-data"
    Environment = var.ENV
    App         = var.app_name
  }

  depends_on = [
    aws_iam_role.jowe_api_lambda_sns,
    aws_iam_role_policy_attachment.jowe_api_lambda_sns_AWSLambdaBasicExecutionRole_attachment,
    aws_iam_role_policy_attachment.jowe_api_lambda_sns_delete_user_data_topic_publish_role_attachment,
    aws_cloudwatch_log_group.common_delete_user_data_lambda_log_group,
  ]
}
