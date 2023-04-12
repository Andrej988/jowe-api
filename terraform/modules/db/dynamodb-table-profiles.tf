resource "aws_dynamodb_table" "weight_tracker_profiles" {
  name         = var.ENV == "dev" ? "weight-tracker-profiles-dev" : "weight-tracker-profiles"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "UserId"

  attribute {
    name = "UserId"
    type = "S"
  }

  # Terraform doesn't care about the non-indexed attributes at creation time
  /*
  attribute {
    name = "TargetWeight"
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
    Name        = "dynamodb-table-weight-tracker-profiles"
    Environment = var.ENV
    App         = var.app_name
  }
}
