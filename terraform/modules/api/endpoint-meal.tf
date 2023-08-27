resource "aws_api_gateway_resource" "meal_resource" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  parent_id   = aws_api_gateway_rest_api.jowe_api.root_resource_id
  path_part   = "meal"
}
