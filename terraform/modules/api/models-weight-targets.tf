resource "aws_api_gateway_model" "weight_targets_insert_request" {
  rest_api_id  = aws_api_gateway_rest_api.jowe_api.id
  name         = "WeightTargetsInsertRequestSchema"
  description  = "Weight Target Insert Request Data"
  content_type = "application/json"

  schema = file("./models/weight/targets/WeightTargetsInsertRequestSchema.json")
}

resource "aws_api_gateway_model" "weight_targets_response" {
  rest_api_id  = aws_api_gateway_rest_api.jowe_api.id
  name         = "WeightTargetsResponseSchema"
  description  = "Weight Targets Response Data"
  content_type = "application/json"

  schema = file("./models/weight/targets/WeightTargetsResponseSchema.json")
}

resource "aws_api_gateway_model" "weight_target_response" {
  rest_api_id  = aws_api_gateway_rest_api.jowe_api.id
  name         = "WeightTargetResponseSchema"
  description  = "Weight Target Response Data"
  content_type = "application/json"

  schema = file("./models/weight/targets/WeightTargetResponseSchema.json")
}
