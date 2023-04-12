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

  request_templates = {
    "application/json" = file("./mapping/MeasurementsRetrieveAllMapping.json")
  }
}
