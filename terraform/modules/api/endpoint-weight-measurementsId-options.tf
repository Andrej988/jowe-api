resource "aws_api_gateway_method" "weight_measurements_id_method_options" {
  rest_api_id   = aws_api_gateway_rest_api.jowe_api.id
  resource_id   = aws_api_gateway_resource.weight_measurements_id_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"

  depends_on = [
    aws_api_gateway_resource.weight_measurements_id_resource
  ]
}

resource "aws_api_gateway_integration" "weight_measurements_id_integration_options" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_measurements_id_resource.id
  http_method = aws_api_gateway_method.weight_measurements_id_method_options.http_method
  type        = "MOCK"

  passthrough_behavior = "WHEN_NO_TEMPLATES"
  request_templates = {
    "application/json" = file("./mapping/common/OptionsIntegrationRequestMapping.vtl")
  }

  depends_on = [
    aws_api_gateway_method.weight_measurements_id_method_options
  ]
}

resource "aws_api_gateway_method_response" "weight_measurements_id_method_res_options_200" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_measurements_id_resource.id
  http_method = aws_api_gateway_method.weight_measurements_id_method_options.http_method
  status_code = 200

  #response_models = {
  #  "application/json" = ""
  #}

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  depends_on = [
    aws_api_gateway_integration.weight_measurements_id_integration_options
  ]
}

resource "aws_api_gateway_integration_response" "weight_measurements_id_integration_res_options_200" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_measurements_id_resource.id
  http_method = aws_api_gateway_method.weight_measurements_id_method_options.http_method
  status_code = aws_api_gateway_method_response.weight_measurements_id_method_res_options_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,OPTIONS,POST'",
    "method.response.header.Access-Control-Allow-Origin"  = local.cors_access_control_allow_origin_value
  }

  depends_on = [
    aws_api_gateway_method_response.weight_measurements_id_method_res_options_200
  ]
}
