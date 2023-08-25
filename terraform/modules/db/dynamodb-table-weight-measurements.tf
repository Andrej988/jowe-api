resource "aws_dynamodb_table" "jowe_measurements" {
  name         = var.ENV == "dev" ? "${var.APP_NAME}-weight-measurements-dev" : "${var.APP_NAME}-weight-measurements"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "UserId"
  range_key    = "MeasurementId"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "MeasurementId"
    type = "S"
  }

  # Terraform doesn't care about the non-indexed attributes at creation time
  /*attribute {
    name = "Date"
    type = "S"
  }

  attribute {
    name = "Notes"
    type = "S"
  }

  attribute {
    name = "Weight"
    type = "N"
  }

  attribute {
    name = "BodyFat"
    type = "N"
  }

  attribute {
    name = "BoneMass"
    type = "N"
  }

  attribute {
    name = "MuscleMass"
    type = "N"
  }

  attribute {
    name = "Water"
    type = "N"
  }

  attribute {
    name = "EnergyExpenditure"
    type = "N"
  }

  attribute {
    name = "Timestamp"
    type = "N"
  }*/

  #ttl {
  #  attribute_name = "TimeToExist"
  #  enabled        = false
  #}

  tags = {
    Name        = "dynamodb-table-${var.APP_NAME}-weight-measurements"
    Environment = var.ENV
    App         = var.APP_NAME
  }

  lifecycle {
    prevent_destroy = true
  }
}
