module "auth" {
  source       = "./terraform/modules/auth"
  ENV          = var.ENV
  app_name     = var.app_name
  project_name = var.project_name
}

module "db" {
  source       = "./terraform/modules/db"
  ENV          = var.ENV
  app_name     = var.app_name
  project_name = var.project_name
}

module "sns_and_sqs" {
  source       = "./terraform/modules/sns_and_sqs"
  ENV          = var.ENV
  app_name     = var.app_name
  project_name = var.project_name
}

module "lambda" {
  source            = "./terraform/modules/lambda"
  ENV               = var.ENV
  app_name          = var.app_name
  project_name      = var.project_name
  dynamodb_policies = module.db.dynamodb_policies
  dynamodb_tables   = module.db.dynamodb_tables
}

module "api" {
  source                = "./terraform/modules/api"
  ENV                   = var.ENV
  DOMAIN_NAME           = var.DOMAIN_NAME
  AWS_CERTIFICATE_ARN   = var.AWS_CERTIFICATE_ARN
  app_name              = var.app_name
  project_name          = var.project_name
  cognito_user_pool_arn = module.auth.cognito_user_pool_arn
  api_lambdas_arns      = module.lambda.api_lambdas_arns
  api_lambdas_names     = module.lambda.api_lambdas_names
}
