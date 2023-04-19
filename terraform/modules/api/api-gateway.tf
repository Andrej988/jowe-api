resource "aws_api_gateway_rest_api" "health_tracker_api" {
  name        = var.ENV == "dev" ? "health-tracker-api-dev" : "health-tracker-api"
  description = "Health Tracker API"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_authorizer" "api_authorizer" {
  name          = var.ENV == "dev" ? "health-tracker-auth-dev" : "health-tracker-auth"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.health_tracker_api.id
  provider_arns = [var.cognito_user_pool_arn]
}
