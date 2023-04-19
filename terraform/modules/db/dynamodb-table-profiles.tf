resource "aws_dynamodb_table" "health_tracker_profiles" {
  name         = var.ENV == "dev" ? "health-tracker-profiles-dev" : "health-tracker-profiles"
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
    Name        = "dynamodb-table-health-tracker-profiles"
    Environment = var.ENV
    App         = var.app_name
  }
}
