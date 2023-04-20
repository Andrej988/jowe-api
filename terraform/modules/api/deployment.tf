resource "aws_api_gateway_deployment" "health_tracker_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.health_tracker_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.health_tracker_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_rest_api.health_tracker_api,

    # Measurements Endpoint
    aws_api_gateway_resource.measurements_resource,
    aws_api_gateway_method.options_measurements_method,
    aws_api_gateway_integration.options_measurements_integration,
    aws_api_gateway_method.get_measurements_method,
    aws_api_gateway_integration.get_measurements_integration,
    aws_api_gateway_method.post_measurements_method,
    aws_api_gateway_integration.post_measurements_integration,

    # Measurements/Id Endpoint
    aws_api_gateway_resource.measurements_id_resource,
    aws_api_gateway_method.options_measurements_id_method,
    aws_api_gateway_integration.options_measurements_id_integration,
    aws_api_gateway_method.get_measurements_id_method,
    aws_api_gateway_integration.get_measurements_id_integration,
    aws_api_gateway_method.delete_measurements_id_method,
    aws_api_gateway_integration.delete_measurements_id_integration,

  ]
}

resource "aws_api_gateway_stage" "health_tracker_stage" {
  deployment_id = aws_api_gateway_deployment.health_tracker_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.health_tracker_api.id
  stage_name    = var.ENV

  depends_on = [
    aws_api_gateway_deployment.health_tracker_api_deployment
  ]
}

#resource "aws_api_gateway_method_settings" "health_tracker_stage_settings" {
#  rest_api_id = aws_api_gateway_rest_api.health_tracker_api.id
#  stage_name  = aws_api_gateway_stage.health_tracker_stage.stage_name
#  method_path = "*/*"
#
#  settings {
#    metrics_enabled = true
#    logging_level   = "INFO"
#  }
#
#  depends_on = [
#    aws_api_gateway_stage.health_tracker_stage
#  ]
#}
