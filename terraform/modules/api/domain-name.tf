resource "aws_api_gateway_domain_name" "custom_domain_name" {
  domain_name              = var.DOMAIN_NAME
  regional_certificate_arn = var.AWS_CERTIFICATE_ARN

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    "App"         = var.app_name
    "Environment" = var.ENV
  }
}

resource "aws_api_gateway_base_path_mapping" "custom_domain_name_stage_mapping" {
  api_id      = aws_api_gateway_rest_api.jowe_api.id
  stage_name  = aws_api_gateway_stage.jowe_stage.stage_name
  domain_name = aws_api_gateway_domain_name.custom_domain_name.domain_name

  depends_on = [
    aws_api_gateway_rest_api.jowe_api,
    aws_api_gateway_stage.jowe_stage,
    aws_api_gateway_domain_name.custom_domain_name
  ]
}
