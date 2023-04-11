module "auth" {
  source = "./terraform/modules/auth"
  ENV = var.ENV
  app_name = var.app_name
}

module "dynamodb" {
  source = "./terraform/modules/dynamodb"
  ENV = var.ENV
  app_name = var.app_name
  dynamodb_measurements_table_name = var.dynamodb_measurements_table_name
}

module "lambda" {
  source = "./terraform/modules/lambda"
  dynamodb_read_only_policy_arn = module.dynamodb.dynamo_db_weight_tracker_read_only_policy
  dynamodb_crud_policy_arn = module.dynamodb.dynamo_db_weight_tracker_crud_policy
  ENV = var.ENV
  app_name = var.app_name
}

module "api" {
  source = "./terraform/modules/api"
  ENV = var.ENV
  app_name = var.app_name
  cognito_user_pool_arn = module.auth.cognito_user_pool_arn
  api_lambdas = module.lambda.api_lambdas
}
