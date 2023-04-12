resource "aws_api_gateway_rest_api" "weight_tracker_api" {
  name        = var.ENV == "dev" ? "weight-tracker-api-dev" : "weight-tracker-api"
  description = "Weight Tracker API"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_authorizer" "api_authorizer" {
  name          = var.ENV == "dev" ? "weight-tracker-auth-dev" : "weight-tracker-auth"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.weight_tracker_api.id
  provider_arns = [var.cognito_user_pool_arn]
}
