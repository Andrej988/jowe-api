resource "aws_api_gateway_resource" "delete_user_data" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  parent_id   = aws_api_gateway_resource.admin_resource.id
  path_part   = "delete-user-data"
}
