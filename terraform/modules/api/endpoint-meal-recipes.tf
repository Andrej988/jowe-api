resource "aws_api_gateway_resource" "meal_recipes_resource" {
  rest_api_id = aws_api_gateway_rest_api.jowe_api.id
  parent_id   = aws_api_gateway_resource.meal_resource.id
  path_part   = "recipes"
}
