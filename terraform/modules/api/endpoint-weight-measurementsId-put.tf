resource "aws_api_gateway_method" "weight_measurements_id_method_put" {
  rest_api_id   = aws_api_gateway_rest_api.jowe_api.id
  resource_id   = aws_api_gateway_resource.weight_measurements_id_resource.id
  http_method   = "PUT"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.jowe_api_authorizer.id

  request_parameters = {
    "method.request.path.proxy" = true,
  }
}

resource "aws_lambda_permission" "gateway_lambda_permission_put_weight_measurement" {
  action        = "lambda:InvokeFunction"
  function_name = var.api_lambdas["weight_measurements_edit"]["function_name"]
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.jowe_api.execution_arn}/*/PUT/weight/measurements/{measurementId}"

  depends_on = [
    aws_api_gateway_rest_api.jowe_api,
    aws_api_gateway_method.weight_measurements_id_method_put
  ]
}

resource "aws_api_gateway_integration" "weight_measurements_id_integration_put" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_measurements_id_resource.id
  http_method = aws_api_gateway_method.weight_measurements_id_method_put.http_method

  # This has to be POST per Lambda integration limitations: Does not support PUT integration method
  integration_http_method = "POST"

  type = "AWS"
  uri  = var.api_lambdas["weight_measurements_edit"]["invoke_arn"]

  passthrough_behavior = "WHEN_NO_TEMPLATES"
  request_templates = {
    "application/json" = file("./mapping/weight/measurements/WeightMeasurementsEditIntegrationRequestMapping.vtl")
  }

  depends_on = [
    aws_api_gateway_method.weight_measurements_id_method_put,
    aws_lambda_permission.gateway_lambda_permission_put_weight_measurement
  ]
}

resource "aws_api_gateway_method_response" "weight_measurements_id_method_put_200" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_measurements_id_resource.id
  http_method = aws_api_gateway_method.weight_measurements_id_method_put.http_method
  status_code = 200

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  depends_on = [
    aws_api_gateway_integration.weight_measurements_id_integration_put
  ]
}

resource "aws_api_gateway_method_response" "weight_measurements_id_method_put_500" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_measurements_id_resource.id
  http_method = aws_api_gateway_method.weight_measurements_id_method_put.http_method
  status_code = 500

  response_models = {
    "application/json" = aws_api_gateway_model.common_error_response.name
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  depends_on = [
    aws_api_gateway_integration.weight_measurements_id_integration_put,
    aws_api_gateway_model.common_error_response
  ]
}

resource "aws_api_gateway_integration_response" "weight_measurements_id_integration_res_put_200" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_measurements_id_resource.id
  http_method = aws_api_gateway_method.weight_measurements_id_method_put.http_method
  status_code = aws_api_gateway_method_response.weight_measurements_id_method_put_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = local.cors_access_control_allow_origin_value
  }

  selection_pattern = ""

  response_templates = {
    "application/json" = file("./mapping/weight/measurements/WeightMeasurementsEditIntegrationResponseMapping.vtl")
  }

  depends_on = [
    aws_api_gateway_method_response.weight_measurements_id_method_put_200
  ]
}

resource "aws_api_gateway_integration_response" "weight_measurements_id_integration_res_put_500" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_measurements_id_resource.id
  http_method = aws_api_gateway_method.weight_measurements_id_method_put.http_method
  status_code = aws_api_gateway_method_response.weight_measurements_id_method_put_500.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = local.cors_access_control_allow_origin_value
  }

  selection_pattern = ".*\"statusCode\":500.*"

  response_templates = {
    "application/json" = file("./mapping/common/ErrorResponseMapping.vtl")
  }

  depends_on = [
    aws_api_gateway_method_response.weight_measurements_id_method_put_500
  ]
}
