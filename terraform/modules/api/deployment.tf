resource "aws_api_gateway_deployment" "health_tracker_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.health_tracker_api.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.health_tracker_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_rest_api.health_tracker_api
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
