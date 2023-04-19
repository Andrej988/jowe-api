resource "aws_api_gateway_resource" "measurements_id_resource" {
  rest_api_id = aws_api_gateway_rest_api.health_tracker_api.id
  parent_id   = aws_api_gateway_resource.measurements_resource.id
  path_part   = "{measurementId}"
}
