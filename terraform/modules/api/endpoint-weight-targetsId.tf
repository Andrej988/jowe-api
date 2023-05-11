resource "aws_api_gateway_resource" "weight_targets_id_resource" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  parent_id   = aws_api_gateway_resource.weight_targets_resource.id
  path_part   = "{recordId}"
}
