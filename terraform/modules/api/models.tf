resource "aws_api_gateway_model" "common_error_response" {
  rest_api_id  = aws_api_gateway_rest_api.jowe_api.id
  name         = "ErrorResponseSchema"
  description  = "Error Response Data"
  content_type = "application/json"

  schema = file("./models/common/ErrorResponseSchema.json")
}

resource "aws_api_gateway_model" "weight_measurments_insert_request" {
  rest_api_id  = aws_api_gateway_rest_api.jowe_api.id
  name         = "MeasurementsInsertRequestSchema"
  description  = "Measurement Insert Request Data"
  content_type = "application/json"

  schema = file("./models/weight/measurements/WeightMeasurementsInsertRequestSchema.json")
}

resource "aws_api_gateway_model" "weight_measurments_response" {
  rest_api_id  = aws_api_gateway_rest_api.jowe_api.id
  name         = "MeasurementsResponseSchema"
  description  = "Measurements Response Data"
  content_type = "application/json"

  schema = file("./models/weight/measurements/WeightMeasurementsResponseSchema.json")
}

resource "aws_api_gateway_model" "weight_measurment_response" {
  rest_api_id  = aws_api_gateway_rest_api.jowe_api.id
  name         = "MeasurementResponseSchema"
  description  = "Measurement Response Data"
  content_type = "application/json"

  schema = file("./models/weight/measurements/WeightMeasurementResponseSchema.json")
}
