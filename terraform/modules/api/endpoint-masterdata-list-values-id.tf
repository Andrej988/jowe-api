resource "aws_api_gateway_resource" "masterdata_list_values_id_resource" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  parent_id   = aws_api_gateway_resource.masterdata_list_values_resource.id
  path_part   = "{listId}"
}
