resource "aws_api_gateway_method" "weight_targets_method_get" {
  rest_api_id   = aws_api_gateway_rest_api.jowe_api.id
  resource_id   = aws_api_gateway_resource.weight_targets_resource.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.jowe_api_authorizer.id

  request_parameters = {
    "method.request.path.proxy" = true,
  }

  depends_on = [
    aws_api_gateway_resource.weight_targets_resource
  ]
}

resource "aws_lambda_permission" "gateway_lambda_permission_retrieve_all_weight_targets" {
  action        = "lambda:InvokeFunction"
  function_name = var.api_lambdas["weight_targets_retrieve"]["function_name"]
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.jowe_api.execution_arn}/*/GET/weight/targets"

  depends_on = [
    aws_api_gateway_rest_api.jowe_api,
    aws_api_gateway_method.weight_targets_method_get
  ]
}

resource "aws_api_gateway_integration" "weight_targets_integration_get" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_targets_resource.id
  http_method = aws_api_gateway_method.weight_targets_method_get.http_method

  # This has to be POST per Lambda integration limitations: Does not support GET integration method
  integration_http_method = "POST"

  type = "AWS"
  uri  = var.api_lambdas["weight_targets_retrieve"]["invoke_arn"]

  passthrough_behavior = "WHEN_NO_TEMPLATES"
  request_templates = {
    "application/json" = file("./mapping/weight/targets/WeightTargetsGetAllIntegrationRequestMapping.vtl")
  }

  depends_on = [
    aws_api_gateway_method.weight_targets_method_get,
    aws_lambda_permission.gateway_lambda_permission_retrieve_all_weight_targets
  ]
}

resource "aws_api_gateway_method_response" "weight_targets_method_get_200" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_targets_resource.id
  http_method = aws_api_gateway_method.weight_targets_method_get.http_method
  status_code = 200

  response_models = {
    "application/json" = aws_api_gateway_model.weight_targets_response.name
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  depends_on = [
    aws_api_gateway_integration.weight_targets_integration_get,
    aws_api_gateway_model.weight_targets_response
  ]
}

resource "aws_api_gateway_method_response" "weight_targets_method_get_400" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_targets_resource.id
  http_method = aws_api_gateway_method.weight_targets_method_get.http_method
  status_code = 400

  response_models = {
    "application/json" = aws_api_gateway_model.common_error_response.name
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  depends_on = [
    aws_api_gateway_integration.weight_targets_integration_get,
    aws_api_gateway_model.common_error_response
  ]
}

resource "aws_api_gateway_method_response" "weight_targets_method_get_500" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_targets_resource.id
  http_method = aws_api_gateway_method.weight_targets_method_get.http_method
  status_code = 500

  response_models = {
    "application/json" = aws_api_gateway_model.common_error_response.name
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  depends_on = [
    aws_api_gateway_integration.weight_targets_integration_get,
    aws_api_gateway_model.common_error_response
  ]
}

resource "aws_api_gateway_integration_response" "weight_targets_integration_get_res_200" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_targets_resource.id
  http_method = aws_api_gateway_method.weight_targets_method_get.http_method
  status_code = aws_api_gateway_method_response.weight_targets_method_get_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = local.cors_access_control_allow_origin_value
  }

  selection_pattern = ""

  response_templates = {
    "application/json" = file("./mapping/weight/targets/WeightTargetsGetAllIntegrationResponseMapping.vtl")
  }

  depends_on = [
    aws_api_gateway_method_response.weight_targets_method_get_200
  ]
}

resource "aws_api_gateway_integration_response" "weight_targets_integration_get_res_400" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_targets_resource.id
  http_method = aws_api_gateway_method.weight_targets_method_get.http_method
  status_code = aws_api_gateway_method_response.weight_targets_method_get_400.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = local.cors_access_control_allow_origin_value
  }

  selection_pattern = ".*\"statusCode\":400.*"

  response_templates = {
    "application/json" = file("./mapping/common/ErrorResponseMapping.vtl")
  }

  depends_on = [
    aws_api_gateway_method_response.weight_targets_method_get_400
  ]
}

resource "aws_api_gateway_integration_response" "weight_targets_integration_res_get_500" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_targets_resource.id
  http_method = aws_api_gateway_method.weight_targets_method_get.http_method
  status_code = aws_api_gateway_method_response.weight_targets_method_get_500.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = local.cors_access_control_allow_origin_value
  }

  selection_pattern = ".*\"statusCode\":500.*"

  response_templates = {
    "application/json" = file("./mapping/common/ErrorResponseMapping.vtl")
  }

  depends_on = [
    aws_api_gateway_method_response.weight_targets_method_get_500
  ]
}
