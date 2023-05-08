resource "aws_api_gateway_rest_api" "jowe_api" {
  name        = var.ENV == "dev" ? "${var.project_name}-dev" : var.project_name
  description = "JoWe (Journal for Wellness) API"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_authorizer" "jowe_api_authorizer" {
  name          = var.ENV == "dev" ? "${var.app_name}-auth-dev" : "${var.app_name}-auth"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.jowe_api.id
  provider_arns = [var.cognito_user_pool_arn]
}

resource "aws_api_gateway_request_validator" "jowe_api_request_validator" {
  name                        = var.ENV == "dev" ? "${var.app_name}-request-validator-dev" : "${var.app_name}-request-validator"
  rest_api_id                 = aws_api_gateway_rest_api.jowe_api.id
  validate_request_body       = true
  validate_request_parameters = true
}
