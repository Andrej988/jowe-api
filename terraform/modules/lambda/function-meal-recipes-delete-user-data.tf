data "archive_file" "meal_recipes_delete_user_data_zip" {
  type        = "zip"
  source_dir  = "${local.lambda_directories["functions_meal_recipes"]}/deleteUserData/"
  output_path = "./temp/meal_recipes_delete_user_data.zip"
}

resource "aws_cloudwatch_log_group" "meal_recipes_delete_user_data_lambda_log_group" {
  name = "${local.cloudwatch_lambdas_log_group_prefix}${local.lambda_function_names["meal_recipes_delete_user_data"]}"

  retention_in_days = local.cloudwatch_lambdas_log_retention_in_days

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
  }
}

resource "aws_lambda_function" "meal_recipes_delete_user_data_lambda" {
  filename      = data.archive_file.meal_recipes_delete_user_data_zip.output_path
  function_name = local.lambda_function_names["meal_recipes_delete_user_data"]
  role          = aws_iam_role.jowe_api_lambda_crud.arn
  handler       = "index.handler"

  source_code_hash = data.archive_file.meal_recipes_delete_user_data_zip.output_base64sha256
  runtime          = local.lambda_runtimes["nodejs_common_runtime"]
  timeout          = 45

  environment {
    variables = {
      TABLE_NAME    = local.lambda_table_names["meal_recipes"]
      SQS_QUEUE_URL = var.sns_and_sqs["sqs_meal_recipes_delete_user_data_queue"]["url"]
    }
  }

  layers = [
    aws_lambda_layer_version.common_layer.arn,
    aws_lambda_layer_version.meal_shared_layer.arn,
  ]

  tags = {
    Name        = "${var.APP_NAME}-api-meal-recipes-delete-user-data"
    Environment = var.ENV
    App         = var.APP_NAME
  }

  depends_on = [
    aws_iam_role.jowe_api_lambda_crud,
    aws_iam_role_policy_attachment.jowe_api_lambda_crud_AWSLambdaBasicExecutionRole_attachment,
    aws_iam_role_policy_attachment.jowe_api_lambda_dynamodb_crud_role_attachment_meal_recipes,
    aws_iam_role_policy_attachment.jowe_api_lambda_sqs_processing_meal_recipes_delete_user_data_role_attachment,
    aws_lambda_layer_version.meal_shared_layer,
    aws_cloudwatch_log_group.meal_recipes_delete_lambda_log_group,
  ]
}

resource "aws_lambda_permission" "meal_recipes_delete_user_data_lambda_cloudwatch_permission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.meal_recipes_delete_user_data_lambda.function_name
  principal     = "events.amazonaws.com"
}
