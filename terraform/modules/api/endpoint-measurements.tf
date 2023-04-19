resource "aws_api_gateway_resource" "measurements_resource" {
  rest_api_id = aws_api_gateway_rest_api.health_tracker_api.id
  parent_id   = aws_api_gateway_rest_api.health_tracker_api.root_resource_id
  path_part   = "measurements"
}
