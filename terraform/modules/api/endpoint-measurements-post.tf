resource "aws_api_gateway_method" "post_measurements_method" {
  rest_api_id   = aws_api_gateway_rest_api.jowe_api.id
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

resource "aws_lambda_permission" "gateway_lambda_permission_post_measurements" {
  action        = "lambda:InvokeFunction"
  function_name = var.api_lambdas_names["insert_measurement"]
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.jowe_api.execution_arn}/*/POST/measurements"

  depends_on = [
    aws_api_gateway_rest_api.jowe_api,
    aws_api_gateway_method.post_measurements_method
  ]
}

resource "aws_api_gateway_integration" "post_measurements_integration" {
  rest_api_id             = aws_api_gateway_rest_api.jowe_api.id
  resource_id             = aws_api_gateway_resource.measurements_resource.id
  http_method             = aws_api_gateway_method.post_measurements_method.http_method
  integration_http_method = aws_api_gateway_method.post_measurements_method.http_method
  type                    = "AWS"
  uri                     = var.api_lambdas_arns["insert_measurement"]

  passthrough_behavior = "WHEN_NO_TEMPLATES"
  request_templates = {
    "application/json" = file("./mapping/MeasurementsPostIntegrationRequestMapping.vtl")
  }

  depends_on = [
    aws_api_gateway_method.post_measurements_method
  ]
}

resource "aws_api_gateway_method_response" "post_measurements_method_200" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.measurements_resource.id
  http_method = aws_api_gateway_method.post_measurements_method.http_method
  status_code = 200

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
    "method.response.header.location"                    = true
  }

  response_models = {
    "application/json" = "Empty"
  }

  depends_on = [
    aws_api_gateway_integration.post_measurements_integration
  ]
}

resource "aws_api_gateway_method_response" "post_measurements_method_400" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.measurements_resource.id
  http_method = aws_api_gateway_method.post_measurements_method.http_method
  status_code = 400

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }

  response_models = {
    "application/json" = "Empty"
  }

  depends_on = [
    aws_api_gateway_integration.post_measurements_integration
  ]
}

resource "aws_api_gateway_integration_response" "post_measurements_integration_res_200" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.measurements_resource.id
  http_method = aws_api_gateway_method.post_measurements_method.http_method
  status_code = aws_api_gateway_method_response.post_measurements_method_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'",
    "method.response.header.location"                    = "integration.response.body.measurementId"
  }

  selection_pattern = ""

  #response_templates = {
  #  "application/json" = "Empty"
  #}

  depends_on = [
    aws_api_gateway_method_response.post_measurements_method_200
  ]
}

resource "aws_api_gateway_integration_response" "post_measurements_integration_res_400" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  resource_id = aws_api_gateway_resource.measurements_resource.id
  http_method = aws_api_gateway_method.post_measurements_method.http_method
  status_code = aws_api_gateway_method_response.post_measurements_method_400.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }

  selection_pattern = ".*\"statusCode\":500.*"

  #response_templates = {
  #  "application/json" = "Empty"
  #}

  depends_on = [
    aws_api_gateway_method_response.post_measurements_method_400
  ]
}
