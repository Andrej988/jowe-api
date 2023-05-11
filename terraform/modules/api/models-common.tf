resource "aws_api_gateway_model" "common_error_response" {
  rest_api_id  = aws_api_gateway_rest_api.jowe_api.id
  name         = "ErrorResponseSchema"
  description  = "Error Response Data"
  content_type = "application/json"

  schema = file("./models/common/ErrorResponseSchema.json")
}
