locals {
  cloudwatch_lambdas_log_group_prefix      = "/aws/lambda/"
  cloudwatch_lambdas_log_retention_in_days = 7

  lambda_runtimes = {
    nodejs_common_runtime = "nodejs18.x"
  }

  lambda_function_names = {
    common_delete_user_data              = var.ENV == "dev" ? "${var.APP_NAME}-api-common-delete-user-data-dev" : "${var.APP_NAME}-api-common-delete-user-data"
    weight_measurements_delete           = var.ENV == "dev" ? "${var.APP_NAME}-api-weight-measurements-delete-dev" : "${var.APP_NAME}-api-weight-measurements-delete"
    weight_measurements_delete_user_data = var.ENV == "dev" ? "${var.APP_NAME}-api-weight-measurements-delete-user-data-dev" : "${var.APP_NAME}-api-weight-measurements-delete-user-data"
    weight_measurements_insert           = var.ENV == "dev" ? "${var.APP_NAME}-api-weight-measurements-insert-dev" : "${var.APP_NAME}-api-weight-measurements-insert"
    weight_measurements_edit             = var.ENV == "dev" ? "${var.APP_NAME}-api-weight-measurements-edit-dev" : "${var.APP_NAME}-api-weight-measurements-edit"
    weight_measurements_retrieve         = var.ENV == "dev" ? "${var.APP_NAME}-api-weight-measurements-retrieve-dev" : "${var.APP_NAME}-api-weight-measurements-retrieve"
    weight_targets_delete                = var.ENV == "dev" ? "${var.APP_NAME}-api-weight-targets-delete-dev" : "${var.APP_NAME}-api-weight-targets-delete"
    weight_targets_delete_user_data      = var.ENV == "dev" ? "${var.APP_NAME}-api-weight-targets-delete-user-data-dev" : "${var.APP_NAME}-api-weight-targets-delete-user-data"
    weight_targets_insert                = var.ENV == "dev" ? "${var.APP_NAME}-api-weight-targets-insert-dev" : "${var.APP_NAME}-api-weight-targets-insert"
    weight_targets_retrieve              = var.ENV == "dev" ? "${var.APP_NAME}-api-weight-targets-retrieve-dev" : "${var.APP_NAME}-api-weight-targets-retrieve"
  }

  lambda_directories = {
    functions_common              = "./lambdas/functions/common/"
    functions_weight_measurements = "./lambdas/functions/weight/measurements"
    functions_weight_targets      = "./lambdas/functions/weight/target"
    layers_base                   = "./lambdas/layers"
  }

  lambda_table_names = {
    weight_measurements = var.dynamodb_tables["weight_measurements"]
    weight_targets      = var.dynamodb_tables["weight_targets"]
  }
}
