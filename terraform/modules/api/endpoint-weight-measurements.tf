resource "aws_api_gateway_resource" "weight_measurements_resource" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  parent_id   = aws_api_gateway_resource.weight_resource.id
  path_part   = "measurements"
}
