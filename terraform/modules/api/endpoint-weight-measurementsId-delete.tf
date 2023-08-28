resource "aws_api_gateway_method" "weight_measurements_id_method_delete" {
  rest_api_id   = aws_api_gateway_rest_api.jowe_api.id
  resource_id   = aws_api_gateway_resource.weight_measurements_id_resource.id
  http_method   = "DELETE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.jowe_api_authorizer.id

  request_parameters = {
    "method.request.path.proxy" = true,
  }
}

resource "aws_lambda_permission" "gateway_lambda_permission_delete_weight_measurement" {
  action        = "lambda:InvokeFunction"
  function_name = var.api_lambdas["weight_measurements_delete"]["function_name"]
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.jowe_api.execution_arn}/*/DELETE/weight/measurements/{measurementId}"

  depends_on = [
    aws_api_gateway_rest_api.jowe_api,
    aws_api_gateway_method.weight_measurements_id_method_delete
  ]
}

resource "aws_api_gateway_integration" "weight_measurements_id_integration_delete" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_measurements_id_resource.id
  http_method = aws_api_gateway_method.weight_measurements_id_method_delete.http_method

  # This has to be POST per Lambda integration limitations: Does not support DELETE integration method
  integration_http_method = "POST"

  type = "AWS"
  uri  = var.api_lambdas["weight_measurements_delete"]["invoke_arn"]

  passthrough_behavior = "WHEN_NO_TEMPLATES"
  request_templates = {
    "application/json" = file("./mapping/weight/measurements/WeightMeasurementsDeleteByIdIntegrationRequestMapping.vtl")
  }

  depends_on = [
    aws_api_gateway_method.weight_measurements_id_method_delete,
    aws_lambda_permission.gateway_lambda_permission_delete_weight_measurement
  ]
}

resource "aws_api_gateway_method_response" "weight_measurements_id_method_delete_200" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_measurements_id_resource.id
  http_method = aws_api_gateway_method.weight_measurements_id_method_delete.http_method
  status_code = 200

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  depends_on = [
    aws_api_gateway_integration.weight_measurements_id_integration_delete
  ]
}

resource "aws_api_gateway_method_response" "weight_measurements_id_method_delete_500" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_measurements_id_resource.id
  http_method = aws_api_gateway_method.weight_measurements_id_method_delete.http_method
  status_code = 500

  response_models = {
    "application/json" = aws_api_gateway_model.common_error_response.name
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  depends_on = [
    aws_api_gateway_integration.weight_measurements_id_integration_delete,
    aws_api_gateway_model.common_error_response
  ]
}

resource "aws_api_gateway_integration_response" "weight_measurements_id_integration_res_delete_200" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_measurements_id_resource.id
  http_method = aws_api_gateway_method.weight_measurements_id_method_delete.http_method
  status_code = aws_api_gateway_method_response.weight_measurements_id_method_delete_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = local.cors_access_control_allow_origin_value
  }

  selection_pattern = ""

  response_templates = {
    "application/json" = "{}"
  }

  depends_on = [
    aws_api_gateway_method_response.weight_measurements_id_method_delete_200
  ]
}

resource "aws_api_gateway_integration_response" "weight_measurements_id_integration_res_delete_500" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_measurements_id_resource.id
  http_method = aws_api_gateway_method.weight_measurements_id_method_delete.http_method
  status_code = aws_api_gateway_method_response.weight_measurements_id_method_delete_500.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = local.cors_access_control_allow_origin_value
  }

  selection_pattern = ".*\"statusCode\":500.*"

  response_templates = {
    "application/json" = file("./mapping/common/ErrorResponseMapping.vtl")
  }

  depends_on = [
    aws_api_gateway_method_response.weight_measurements_id_method_delete_500
  ]
}
