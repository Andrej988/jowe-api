locals {
  cloudwatch_lambdas_log_group_prefix      = "/aws/lambda/"
  cloudwatch_lambdas_log_retention_in_days = 7

  lambda_runtimes = {
    nodejs_common_runtime = "nodejs18.x"
  }

  lambda_function_names = {
    common_delete_user_data              = var.ENV == "dev" ? "${var.APP_NAME}-api-common-delete-user-data-dev" : "${var.APP_NAME}-api-common-delete-user-data"
    list_values_retrieve                 = var.ENV == "dev" ? "${var.APP_NAME}-api-list-values-retrieve-dev" : "${var.APP_NAME}-api-list-values-retrieve"
    meal_recipes_delete                  = var.ENV == "dev" ? "${var.APP_NAME}-api-meal-recipes-delete-dev" : "${var.APP_NAME}-api-meal-recipes-delete"
    meal_recipes_delete_user_data        = var.ENV == "dev" ? "${var.APP_NAME}-api-meal-recipes-delete-user-data-dev" : "${var.APP_NAME}-api-meal-recipes-delete-user-data"
    meal_recipes_insert                  = var.ENV == "dev" ? "${var.APP_NAME}-api-meal-recipes-insert-dev" : "${var.APP_NAME}-api-meal-recipes-insert"
    meal_recipes_edit                    = var.ENV == "dev" ? "${var.APP_NAME}-api-meal-recipes-edit-dev" : "${var.APP_NAME}-api-meal-recipes-edit"
    meal_recipes_retrieve                = var.ENV == "dev" ? "${var.APP_NAME}-api-meal-recipes-retrieve-dev" : "${var.APP_NAME}-api-meal-recipes-retrieve"
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
    functions_list_values         = "./lambdas/functions/masterdata/list_values"
    functions_meal_recipes        = "./lambdas/functions/meal/recipes"
    functions_weight_measurements = "./lambdas/functions/weight/measurements"
    functions_weight_targets      = "./lambdas/functions/weight/target"
    layers_base                   = "./lambdas/layers"
  }

  lambda_table_names = {
    list_values         = var.dynamodb_tables["list_values"]["name"]
    meal_recipes        = var.dynamodb_tables["meal_recipes"]["name"]
    weight_measurements = var.dynamodb_tables["weight_measurements"]["name"]
    weight_targets      = var.dynamodb_tables["weight_targets"]["name"]
  }
}
