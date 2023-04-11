variable "app_name" {}
variable "ENV" {}
variable "cognito_user_pool_arn" {}
variable "api_lambdas" {}

resource "aws_api_gateway_rest_api" "weight_tracker_api" {
  name        = var.ENV == "dev" ? "weight-tracker-api-dev" : "weight-tracker-api"
  description = "Weight Tracker API"
  endpoint_configuration {
    types = [ "REGIONAL" ]
  }
}

resource "aws_api_gateway_authorizer" "api_authorizer" {
  name          = "weight-tracker-auth"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.weight_tracker_api.id
  provider_arns = [var.cognito_user_pool_arn]
}

resource "aws_api_gateway_resource" "measurements_resource" {
  rest_api_id = aws_api_gateway_rest_api.weight_tracker_api.id
  parent_id   = aws_api_gateway_rest_api.weight_tracker_api.root_resource_id
  path_part   = "measurements"
}

resource "aws_api_gateway_method" "get_measurements_method" {
  rest_api_id   = aws_api_gateway_rest_api.weight_tracker_api.id
  resource_id   = aws_api_gateway_resource.measurements_resource.id
  http_method   = "GET" 
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.api_authorizer.id

  request_parameters = {
    "method.request.path.proxy" = true,
  }
}

resource "aws_api_gateway_integration" "get_measurements_integration" {
  rest_api_id             = aws_api_gateway_rest_api.weight_tracker_api.id
  resource_id             = aws_api_gateway_resource.measurements_resource.id
  http_method             = aws_api_gateway_method.get_measurements_method.http_method
  integration_http_method = aws_api_gateway_method.get_measurements_method.http_method
  type                    = "AWS"
  uri                     = var.api_lambdas["retrieve_measurements"]
}
