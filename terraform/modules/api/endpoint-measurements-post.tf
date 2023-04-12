resource "aws_api_gateway_method" "post_measurements_method" {
  rest_api_id   = aws_api_gateway_rest_api.weight_tracker_api.id
  resource_id   = aws_api_gateway_resource.measurements_resource.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.api_authorizer.id

  request_models = {
    "application/json" = aws_api_gateway_model.measurments_insert_request_data.name
  }

  request_parameters = {
    "method.request.path.proxy" = true,
  }

  depends_on = [
    aws_api_gateway_resource.measurements_resource
  ]
}

resource "aws_api_gateway_integration" "post_measurements_integration" {
  rest_api_id             = aws_api_gateway_rest_api.weight_tracker_api.id
  resource_id             = aws_api_gateway_resource.measurements_resource.id
  http_method             = aws_api_gateway_method.post_measurements_method.http_method
  integration_http_method = aws_api_gateway_method.post_measurements_method.http_method
  type                    = "AWS"
  uri                     = var.api_lambdas["insert_measurement"]

  request_templates = {
    "application/json" = file("./mapping/MeasurementsPostIntegrationRequestMapping.vtl")
  }

  depends_on = [
    aws_api_gateway_method.post_measurements_method
  ]
}

resource "aws_api_gateway_method_response" "post_measurements_method_201" {
  rest_api_id = aws_api_gateway_rest_api.weight_tracker_api.id
  resource_id = aws_api_gateway_resource.measurements_resource.id
  http_method = aws_api_gateway_method.post_measurements_method.http_method
  status_code = 201

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
    "method.response.header.location" = true
  }

  depends_on = [
    aws_api_gateway_integration.post_measurements_integration
  ]
}

resource "aws_api_gateway_integration_response" "post_measurements_integration_res_201" {
  rest_api_id = aws_api_gateway_rest_api.weight_tracker_api.id
  resource_id = aws_api_gateway_resource.measurements_resource.id
  http_method = aws_api_gateway_method.post_measurements_method.http_method
  status_code = aws_api_gateway_method_response.post_measurements_method_201.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'",
    "method.response.header.location" = "integration.response.body.measurementId"
  }

  #response_templates = {
  #  "application/json" = "Empty"
  #}

  depends_on = [
    aws_api_gateway_method_response.post_measurements_method_201
  ]
}


