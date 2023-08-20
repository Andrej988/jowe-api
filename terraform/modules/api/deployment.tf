resource "aws_api_gateway_deployment" "jowe_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.jowe_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }

  # Added to force terraform to recreate deployment on each run
  # This is a work around and will always be marked as a change
  variables = {
    deployed_at = "${timestamp()}"
  }

  depends_on = [
    aws_api_gateway_rest_api.jowe_api,

    # Admin resource
    aws_api_gateway_resource.admin_resource,

    # Delete User Data Endpoint
    aws_api_gateway_resource.delete_user_data,
    aws_api_gateway_method.delete_user_data_method_options,
    aws_api_gateway_integration.delete_user_data_integration_options,
    aws_api_gateway_method.delete_user_data_method_post,
    aws_api_gateway_integration.delete_user_data_integration_post,

    # Weight Resource
    aws_api_gateway_resource.weight_resource,

    # Measurements Endpoint
    aws_api_gateway_resource.weight_measurements_resource,
    aws_api_gateway_method.weight_measurements_method_options,
    aws_api_gateway_integration.weight_measurements_integration_options,
    aws_api_gateway_method.weight_measurements_method_get,
    aws_api_gateway_integration.weight_measurements_integration_get,
    aws_api_gateway_method.weight_measurements_method_post,
    aws_api_gateway_integration.weight_measurements_integration_post,

    # Measurements/Id Endpoint
    aws_api_gateway_resource.weight_measurements_id_resource,
    aws_api_gateway_method.weight_measurements_id_method_options,
    aws_api_gateway_integration.weight_measurements_id_integration_options,
    aws_api_gateway_method.weight_measurements_id_method_get,
    aws_api_gateway_integration.weight_measurements_id_integration_get,
    aws_api_gateway_method.weight_measurements_id_method_delete,
    aws_api_gateway_integration.weight_measurements_id_integration_delete,
    aws_api_gateway_method.weight_measurements_id_method_put,
    aws_api_gateway_integration.weight_measurements_id_integration_put,

  ]
}

resource "aws_api_gateway_stage" "jowe_stage" {
  deployment_id = aws_api_gateway_deployment.jowe_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.jowe_api.id
  stage_name    = var.ENV

  depends_on = [
    aws_api_gateway_deployment.jowe_api_deployment
  ]
}

resource "aws_api_gateway_method_settings" "jowe_stage_settings" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  stage_name  = aws_api_gateway_stage.jowe_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled    = true
    logging_level      = "INFO"
    data_trace_enabled = true
  }

  depends_on = [
    aws_api_gateway_stage.jowe_stage
  ]
}
