resource "aws_api_gateway_method" "get_measurements_method" {
  rest_api_id   = aws_api_gateway_rest_api.jowe_api.id
  resource_id   = aws_api_gateway_resource.measurements_resource.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.api_authorizer.id

  request_parameters = {
    "method.request.path.proxy" = true,
  }

  depends_on = [
    aws_api_gateway_resource.measurements_resource
  ]
}

resource "aws_lambda_permission" "gateway_lambda_permission_retrieve_all_measurements" {
  action        = "lambda:InvokeFunction"
  function_name = var.api_lambdas_names["weight_measurements_retrieve"]
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.jowe_api.execution_arn}/*/GET/measurements"

  depends_on = [
    aws_api_gateway_rest_api.jowe_api,
    aws_api_gateway_method.get_measurements_method
  ]
}

resource "aws_api_gateway_integration" "get_measurements_integration" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.measurements_resource.id
  http_method = aws_api_gateway_method.get_measurements_method.http_method

  # This has to be POST per Lambda integration limitations: Does not support GET integration method
  integration_http_method = "POST"

  type = "AWS"
  uri  = var.api_lambdas_arns["weight_measurements_retrieve"]

  passthrough_behavior = "WHEN_NO_TEMPLATES"
  request_templates = {
    "application/json" = file("./mapping/weight/measurements/MeasurementsGetIntegrationRequestMapping.vtl")
  }

  depends_on = [
    aws_api_gateway_method.get_measurements_method,
    aws_lambda_permission.gateway_lambda_permission_retrieve_all_measurements
  ]
}

resource "aws_api_gateway_method_response" "get_measurements_method_200" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.measurements_resource.id
  http_method = aws_api_gateway_method.get_measurements_method.http_method
  status_code = 200

  response_models = {
    "application/json" = aws_api_gateway_model.measurments_response_data.name
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  depends_on = [
    aws_api_gateway_integration.get_measurements_integration,
    aws_api_gateway_model.measurments_response_data
  ]
}

resource "aws_api_gateway_integration_response" "get_measurements_integration_res_200" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.measurements_resource.id
  http_method = aws_api_gateway_method.get_measurements_method.http_method
  status_code = aws_api_gateway_method_response.get_measurements_method_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  response_templates = {
    "application/json" = file("./mapping/weight/measurements/MeasurementsGetIntegrationResponseMapping.vtl")
  }

  depends_on = [
    aws_api_gateway_method_response.get_measurements_method_200
  ]
}
