resource "aws_api_gateway_rest_api" "jowe_api" {
  name        = var.ENV == "dev" ? "${var.PROJECT_NAME}-dev" : var.PROJECT_NAME
  description = "JoWe (Journal for Wellness) API"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_authorizer" "jowe_api_authorizer" {
  name          = var.ENV == "dev" ? "${var.APP_NAME}-auth-dev" : "${var.APP_NAME}-auth"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.jowe_api.id
  provider_arns = [var.cognito_user_pool_arn]
}

resource "aws_api_gateway_request_validator" "jowe_api_request_validator" {
  name                        = var.ENV == "dev" ? "${var.APP_NAME}-request-validator-dev" : "${var.APP_NAME}-request-validator"
  rest_api_id                 = aws_api_gateway_rest_api.jowe_api.id
  validate_request_body       = true
  validate_request_parameters = true
}

resource "aws_api_gateway_gateway_response" "jowe_api_gateway_response_default_4XX" {
  rest_api_id   = aws_api_gateway_rest_api.jowe_api.id
  response_type = "DEFAULT_4XX"

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"  = local.cors_access_control_allow_origin_value
    "gatewayresponse.header.Access-Control-Allow-Methods" = "'OPTIONS'"
  }

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  depends_on = [
    aws_api_gateway_rest_api.jowe_api,
  ]
}

resource "aws_api_gateway_gateway_response" "jowe_api_gateway_response_default_5XX" {
  rest_api_id   = aws_api_gateway_rest_api.jowe_api.id
  response_type = "DEFAULT_5XX"

  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin"  = local.cors_access_control_allow_origin_value
    "gatewayresponse.header.Access-Control-Allow-Methods" = "'OPTIONS'"
  }

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  depends_on = [
    aws_api_gateway_rest_api.jowe_api,
  ]
}
