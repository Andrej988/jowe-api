resource "aws_api_gateway_model" "masterdata_list_values_response" {
  rest_api_id  = aws_api_gateway_rest_api.jowe_api.id
  name         = "ListValuesResponseSchema"
  description  = "Masterdata List Values Response Data"
  content_type = "application/json"

  schema = file("./models/masterdata/list_values/ListValuesResponseSchema.json")
}
