module "auth" {
  source = "./terraform/modules/auth"
  ENV = var.ENV
  app_name = var.app_name
}

module "db" {
  source = "./terraform/modules/db"
  ENV = var.ENV
  app_name = var.app_name
}

module "lambda" {
  source = "./terraform/modules/lambda"
  dynamodb_policies = module.db.dynamodb_policies
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
