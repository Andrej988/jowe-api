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
