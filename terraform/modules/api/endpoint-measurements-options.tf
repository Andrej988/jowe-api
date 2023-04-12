resource "aws_api_gateway_method" "options_measurements_method" {
  rest_api_id   = aws_api_gateway_rest_api.weight_tracker_api.id
  resource_id   = aws_api_gateway_resource.measurements_resource.id
  http_method   = "OPTIONS" 
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_measurements_method_200" {
    rest_api_id   = aws_api_gateway_rest_api.weight_tracker_api.id
    resource_id   = aws_api_gateway_resource.measurements_resource.id
    http_method   = aws_api_gateway_method.options_measurements_method.http_method
    status_code   = 200

    response_models = {
        "application/json" = "Empty"
    }
    
    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = true,
        "method.response.header.Access-Control-Allow-Methods" = true,
        "method.response.header.Access-Control-Allow-Origin" = true
    }

    depends_on = [
      aws_api_gateway_method.options_measurements_method
    ]
}

resource "aws_api_gateway_integration" "options_measurements_integration" {
  rest_api_id             = aws_api_gateway_rest_api.weight_tracker_api.id
  resource_id             = aws_api_gateway_resource.measurements_resource.id
  http_method             = aws_api_gateway_method.options_measurements_method.http_method
  type                    = "MOCK"

  request_templates = {
    "application/json" = file("./mapping/OptionsIntegrationRequestStatusCode.json")
  }

  depends_on = [
    aws_api_gateway_method.options_measurements_method
  ]
}

resource "aws_api_gateway_integration_response" "options_measurements_integration_res" {
    rest_api_id = aws_api_gateway_rest_api.weight_tracker_api.id
    resource_id = aws_api_gateway_resource.measurements_resource.id
    http_method = aws_api_gateway_method.options_measurements_method.http_method
    status_code = aws_api_gateway_method_response.options_measurements_method_200.status_code

    response_parameters = {
        "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
        "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
        "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    }
    
    depends_on = [
      aws_api_gateway_integration.options_measurements_integration,
      aws_api_gateway_method.options_measurements_method
    ]
}