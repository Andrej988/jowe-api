resource "aws_api_gateway_model" "weight_measurments_insert_request" {
  rest_api_id  = aws_api_gateway_rest_api.jowe_api.id
  name         = "WeightMeasurementsInsertRequestSchema"
  description  = "Weight measurement Insert Request Data"
  content_type = "application/json"

  schema = file("./models/weight/measurements/WeightMeasurementsInsertRequestSchema.json")
}

resource "aws_api_gateway_model" "weight_measurments_response" {
  rest_api_id  = aws_api_gateway_rest_api.jowe_api.id
  name         = "WeightMeasurementsResponseSchema"
  description  = "Weight measurements Response Data"
  content_type = "application/json"

  schema = file("./models/weight/measurements/WeightMeasurementsResponseSchema.json")
}

resource "aws_api_gateway_model" "weight_measurment_response" {
  rest_api_id  = aws_api_gateway_rest_api.jowe_api.id
  name         = "WeightMeasurementResponseSchema"
  description  = "Weight measurement Response Data"
  content_type = "application/json"

  schema = file("./models/weight/measurements/WeightMeasurementResponseSchema.json")
}
