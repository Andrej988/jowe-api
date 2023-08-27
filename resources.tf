module "auth" {
  source       = "./terraform/modules/auth"
  ENV          = var.ENV
  APP_NAME     = var.APP_NAME
  PROJECT_NAME = var.PROJECT_NAME
}

module "db" {
  source       = "./terraform/modules/db"
  ENV          = var.ENV
  APP_NAME     = var.APP_NAME
  PROJECT_NAME = var.PROJECT_NAME
}

module "sns_and_sqs" {
  source       = "./terraform/modules/sns_and_sqs"
  ENV          = var.ENV
  APP_NAME     = var.APP_NAME
  PROJECT_NAME = var.PROJECT_NAME
}

module "lambda" {
  source                  = "./terraform/modules/lambda"
  ENV                     = var.ENV
  APP_NAME                = var.APP_NAME
  PROJECT_NAME            = var.PROJECT_NAME
  USER_DATA_DELETION_CRON = var.USER_DATA_DELETION_CRON
  dynamodb_tables         = module.db.dynamodb_tables
  sns_and_sqs             = module.sns_and_sqs.sns_and_sqs
}

module "api" {
  source                = "./terraform/modules/api"
  AWS_REGION            = var.AWS_REGION
  ENV                   = var.ENV
  DOMAIN_API            = var.DOMAIN_API
  AWS_CERTIFICATE_ARN   = var.AWS_CERTIFICATE_ARN
  APP_NAME              = var.APP_NAME
  PROJECT_NAME          = var.PROJECT_NAME
  cognito_user_pool_arn = module.auth.cognito_user_pool_arn
  api_lambdas           = module.lambda.api_lambdas
  sns_and_sqs           = module.sns_and_sqs.sns_and_sqs
  CORS_ALLOWED_ORIGIN   = var.CORS_ALLOWED_ORIGIN
}
