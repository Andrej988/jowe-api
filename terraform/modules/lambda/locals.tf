locals {
  cloudwatch_lambdas_log_group_prefix      = "/aws/lambda/"
  cloudwatch_lambdas_log_retention_in_days = 7

  lambdas_common_runtime = "nodejs18.x"

  lambda_layers_directory_base = "./lambdas/layers"

  weight_measurements_delete_lambda_name   = var.ENV == "dev" ? "${var.app_name}-api-weight-measurements-delete-dev" : "${var.app_name}-api-weight-measurements-delete"
  weight_measurements_insert_lambda_name   = var.ENV == "dev" ? "${var.app_name}-api-weight-measurements-insert-dev" : "${var.app_name}-api-weight-measurements-insert"
  weight_measurements_retrieve_lambda_name = var.ENV == "dev" ? "${var.app_name}-api-weight-measurements-retrieve-dev" : "${var.app_name}-api-weight-measurements-retrieve"
  weight_targets_delete_lambda_name        = var.ENV == "dev" ? "${var.app_name}-api-weight-targets-delete-dev" : "${var.app_name}-api-weight-targets-delete"
  weight_targets_insert_lambda_name        = var.ENV == "dev" ? "${var.app_name}-api-weight-targets-insert-dev" : "${var.app_name}-api-weight-targets-insert"
  weight_targets_retrieve_lambda_name      = var.ENV == "dev" ? "${var.app_name}-api-weight-targets-retrieve-dev" : "${var.app_name}-api-weight-targets-retrieve"

  weight_measurements_lambdas_directory = "./lambdas/functions/weight/measurements"
  weight_targets_lambdas_directory      = "./lambdas/functions/weight/target"

  weight_measurements_table_name = var.dynamodb_tables["weight_measurements"]
  weight_targets_table_name      = var.dynamodb_tables["weight_targets"]
}
