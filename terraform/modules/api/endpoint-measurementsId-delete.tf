resource "aws_api_gateway_method" "delete_measurements_id_method" {
  rest_api_id   = aws_api_gateway_rest_api.jowe_api.id
  resource_id   = aws_api_gateway_resource.measurements_id_resource.id
  http_method   = "DELETE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.api_authorizer.id

  request_parameters = {
    "method.request.path.proxy" = true,
  }
}

resource "aws_api_gateway_integration" "delete_measurements_id_integration" {
  rest_api_id             = aws_api_gateway_rest_api.jowe_api.id
  resource_id             = aws_api_gateway_resource.measurements_id_resource.id
  http_method             = aws_api_gateway_method.delete_measurements_id_method.http_method
  integration_http_method = aws_api_gateway_method.delete_measurements_id_method.http_method
  type                    = "AWS"
  uri                     = var.api_lambdas_arns["delete_measurement"]

  request_templates = {
    "application/json" = file("./mapping/MeasurementIdDeleteIntegrationRequestMapping.vtl")
  }
}

resource "aws_api_gateway_method_response" "delete_measurements_id_method_200" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.measurements_id_resource.id
  http_method = aws_api_gateway_method.delete_measurements_id_method.http_method
  status_code = 200

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  depends_on = [
    aws_api_gateway_integration.delete_measurements_id_integration
  ]
}

resource "aws_api_gateway_integration_response" "delete_measurements_id_integration_res_200" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.measurements_id_resource.id
  http_method = aws_api_gateway_method.delete_measurements_id_method.http_method
  status_code = aws_api_gateway_method_response.delete_measurements_id_method_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = "{}"
  }

  depends_on = [
    aws_api_gateway_method_response.delete_measurements_id_method_200
  ]
}

