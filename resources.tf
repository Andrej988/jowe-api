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
  source               = "./terraform/modules/lambda"
  ENV                  = var.ENV
  app_name             = var.app_name
  project_name         = var.project_name
  dynamodb_policies    = module.db.dynamodb_policies
  dynamodb_tables      = module.db.dynamodb_tables
  sns_and_sqs_arns     = module.sns_and_sqs.sns_and_sqs_arns
  sns_and_sqs_policies = module.sns_and_sqs.sns_and_sqs_policies
}

module "api" {
  source                = "./terraform/modules/api"
  AWS_REGION            = var.AWS_REGION
  ENV                   = var.ENV
  DOMAIN_API            = var.DOMAIN_API
  AWS_CERTIFICATE_ARN   = var.AWS_CERTIFICATE_ARN
  app_name              = var.app_name
  project_name          = var.project_name
  cognito_user_pool_arn = module.auth.cognito_user_pool_arn
  api_lambdas_arns      = module.lambda.api_lambdas_arns
  api_lambdas_names     = module.lambda.api_lambdas_names
  sns_and_sqs_arns      = module.sns_and_sqs.sns_and_sqs_arns
  sns_and_sqs_policies  = module.sns_and_sqs.sns_and_sqs_policies
  CORS_ALLOWED_ORIGIN   = var.CORS_ALLOWED_ORIGIN
}
