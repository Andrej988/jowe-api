resource "aws_api_gateway_method" "weight_targets_method_post" {
  rest_api_id   = aws_api_gateway_rest_api.jowe_api.id
  resource_id   = aws_api_gateway_resource.weight_targets_resource.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.jowe_api_authorizer.id

  request_models = {
    "application/json" = aws_api_gateway_model.weight_targets_insert_request.name
  }

  request_parameters = {
    "method.request.path.proxy" = true,
  }

  depends_on = [
    aws_api_gateway_resource.weight_targets_resource,
    aws_api_gateway_model.weight_targets_insert_request
  ]
}

resource "aws_lambda_permission" "gateway_lambda_permission_post_weight_targets" {
  action        = "lambda:InvokeFunction"
  function_name = var.api_lambdas_names["weight_targets_insert"]
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.jowe_api.execution_arn}/*/POST/weight/targets"

  depends_on = [
    aws_api_gateway_rest_api.jowe_api,
    aws_api_gateway_method.weight_targets_method_post
  ]
}

resource "aws_api_gateway_integration" "weight_targets_integration_post" {
  rest_api_id             = aws_api_gateway_rest_api.jowe_api.id
  resource_id             = aws_api_gateway_resource.weight_targets_resource.id
  http_method             = aws_api_gateway_method.weight_targets_method_post.http_method
  integration_http_method = aws_api_gateway_method.weight_targets_method_post.http_method
  type                    = "AWS"
  uri                     = var.api_lambdas_arns["weight_targets_insert"]

  passthrough_behavior = "WHEN_NO_TEMPLATES"
  request_templates = {
    "application/json" = file("./mapping/weight/targets/WeightTargetsInsertIntegrationRequestMapping.vtl")
  }

  depends_on = [
    aws_api_gateway_method.weight_targets_method_post,
    aws_lambda_permission.gateway_lambda_permission_post_weight_targets
  ]
}

resource "aws_api_gateway_method_response" "weight_targets_method_post_200" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_targets_resource.id
  http_method = aws_api_gateway_method.weight_targets_method_post.http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
    "method.response.header.location"                    = true
  }

  response_models = {
    "application/json" = "Empty"
  }

  depends_on = [
    aws_api_gateway_integration.weight_targets_integration_post
  ]
}

resource "aws_api_gateway_method_response" "weight_targets_method_post_400" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_targets_resource.id
  http_method = aws_api_gateway_method.weight_targets_method_post.http_method
  status_code = 400

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  response_models = {
    "application/json" = aws_api_gateway_model.common_error_response.name
  }

  depends_on = [
    aws_api_gateway_integration.weight_targets_integration_post,
    aws_api_gateway_model.common_error_response
  ]
}

resource "aws_api_gateway_method_response" "weight_targets_method_post_500" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_targets_resource.id
  http_method = aws_api_gateway_method.weight_targets_method_post.http_method
  status_code = 500

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  response_models = {
    "application/json" = aws_api_gateway_model.common_error_response.name
  }

  depends_on = [
    aws_api_gateway_integration.weight_targets_integration_post,
    aws_api_gateway_model.common_error_response
  ]
}

resource "aws_api_gateway_integration_response" "weight_targets_integration_res_post_200" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_targets_resource.id
  http_method = aws_api_gateway_method.weight_targets_method_post.http_method
  status_code = aws_api_gateway_method_response.weight_targets_method_post_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = local.cors_access_control_allow_origin_value,
    "method.response.header.location"                    = "integration.response.body.resourceId"
  }

  selection_pattern = ""

  response_templates = {
    "application/json" = file("./mapping/weight/targets/WeightTargetsInsertIntegrationResponseMapping.vtl")
  }

  depends_on = [
    aws_api_gateway_method_response.weight_targets_method_post_200
  ]
}

resource "aws_api_gateway_integration_response" "weight_targets_integration_res_post_400" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_targets_resource.id
  http_method = aws_api_gateway_method.weight_targets_method_post.http_method
  status_code = aws_api_gateway_method_response.weight_targets_method_post_400.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = local.cors_access_control_allow_origin_value
  }

  selection_pattern = ".*\"statusCode\":400.*"

  response_templates = {
    "application/json" = file("./mapping/common/ErrorResponseMapping.vtl")
  }


  depends_on = [
    aws_api_gateway_method_response.weight_targets_method_post_400
  ]
}

resource "aws_api_gateway_integration_response" "weight_targets_integration_res_post_500" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.weight_targets_resource.id
  http_method = aws_api_gateway_method.weight_targets_method_post.http_method
  status_code = aws_api_gateway_method_response.weight_targets_method_post_500.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = local.cors_access_control_allow_origin_value
  }

  selection_pattern = ".*\"statusCode\":500.*"

  response_templates = {
    "application/json" = file("./mapping/common/ErrorResponseMapping.vtl")
  }

  depends_on = [
    aws_api_gateway_method_response.weight_targets_method_post_500
  ]
}

