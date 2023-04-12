resource "aws_api_gateway_model" "measurments_insert_request_data" {
  rest_api_id  = aws_api_gateway_rest_api.weight_tracker_api.id
  name         = "MeasurementsInsertRequestData"
  description  = "Measurement Insert Request Data"
  content_type = "application/json"

  schema = file("./models/MeasurementsInsertRequestData.json")
}

resource "aws_api_gateway_model" "measurments_response_data" {
  rest_api_id  = aws_api_gateway_rest_api.weight_tracker_api.id
  name         = "MeasurementsResponseData"
  description  = "Measurement Response Data"
  content_type = "application/json"

  schema = file("./models/MeasurementsResponseData.json")
}
