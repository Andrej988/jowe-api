resource "aws_api_gateway_domain_name" "custom_domain_name" {
  domain_name              = var.DOMAIN_NAME
  regional_certificate_arn = var.CERTIFICATE_ARN

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = {
    "App"         = var.app_name
    "Environment" = var.ENV
  }
}
