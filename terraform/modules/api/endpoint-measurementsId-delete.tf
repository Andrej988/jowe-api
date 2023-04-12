resource "aws_api_gateway_method" "delete_measurements_id_method" {
  rest_api_id   = aws_api_gateway_rest_api.weight_tracker_api.id
  resource_id   = aws_api_gateway_resource.measurements_id_resource.id
  http_method   = "DELETE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.api_authorizer.id

  request_parameters = {
    "method.request.path.proxy" = true,
  }
}

resource "aws_api_gateway_integration" "delete_measurements_id_integration" {
  rest_api_id             = aws_api_gateway_rest_api.weight_tracker_api.id
  resource_id             = aws_api_gateway_resource.measurements_id_resource.id
  http_method             = aws_api_gateway_method.delete_measurements_id_method.http_method
  integration_http_method = aws_api_gateway_method.delete_measurements_id_method.http_method
  type                    = "AWS"
  uri                     = var.api_lambdas["retrieve_measurements"]
}
