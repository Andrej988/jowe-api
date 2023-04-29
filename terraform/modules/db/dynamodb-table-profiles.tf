resource "aws_dynamodb_table" "jowe_profiles" {
  name         = var.ENV == "dev" ? "${var.app_name}-profiles-dev" : "${var.app_name}-profiles"
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
    Name        = "dynamodb-table-${var.app_name}-profiles"
    Environment = var.ENV
    App         = var.app_name
  }
}
